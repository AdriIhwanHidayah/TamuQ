const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const app = express();
const port = 3000;
const dataFilePath = path.join(__dirname, 'data.json');

// Middleware
app.use(cors());
app.use(express.json());

// Test route
app.get('/hello', (req, res) => {
  res.send({ message: 'Hello from Express!' });
});

// Tambah data tamu
app.post('/guest', (req, res) => {
  try {
    const guest = req.body;

    // Baca file data lama
    let guests = [];
    if (fs.existsSync(dataFilePath)) {
      const fileContent = fs.readFileSync(dataFilePath, 'utf-8');
      if (fileContent) {
        guests = JSON.parse(fileContent);
      }
    }

    // Tambah data baru
    guests.push(guest);

    // Simpan ulang
    fs.writeFileSync(dataFilePath, JSON.stringify(guests, null, 2), 'utf-8');

    res.status(200).json({ success: true, message: 'Guest added successfully' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error saving guest', error: error.message });
  }
});

// Ambil semua data tamu
app.get('/guest', (req, res) => {
  try {
    if (!fs.existsSync(dataFilePath)) {
      return res.json([]);
    }

    const data = fs.readFileSync(dataFilePath, 'utf-8');
    const guests = data ? JSON.parse(data) : [];

    res.json(guests);
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error reading data', error: error.message });
  }
});

// Hapus tamu berdasarkan ID
app.delete('/guest/:id', (req, res) => {
  try {
    const { id } = req.params;

    if (!fs.existsSync(dataFilePath)) {
      return res.status(404).json({ success: false, message: 'Data not found' });
    }

    const fileContent = fs.readFileSync(dataFilePath, 'utf-8');
    let guests = fileContent ? JSON.parse(fileContent) : [];

    const initialLength = guests.length;
    guests = guests.filter(g => g.id !== id);

    if (guests.length === initialLength) {
      return res.status(404).json({ success: false, message: 'Guest not found' });
    }

    fs.writeFileSync(dataFilePath, JSON.stringify(guests, null, 2), 'utf-8');

    res.status(200).json({ success: true, message: 'Guest deleted successfully' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Error deleting guest', error: error.message });
  }
});

// Jalankan server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});

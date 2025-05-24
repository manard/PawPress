const express = require('express');
const cors = require('cors');
const db = require('./db');

const app = express();
app.use(cors());
app.use(express.json());
//Sign up End Point
app.post('/signup', (req, res) => {
  console.log('Received signup data:', req.body);
  const { username, email, password, firstName , lastName, phoneNumber, role , address} = req.body;
 console.log("Role:", role); 
  const sql = `INSERT INTO appuser (username, email, password,firstName,lastName, phoneNumber, role, address)
               VALUES (?, ?, ?,?,?,?, ?,?)`;
  db.query(sql, [username, email, password,firstName,lastName, phoneNumber, role,address], (err, result) => {
    if (err) {
      console.error('Error during registration:', err);
      return res.status(500).json({ message: 'Database error' });
    }

    res.status(200).json({ message: 'User registered successfully' });
  });
});
//Login
app.listen(3000,'0.0.0.0', () => {
  console.log('Server running on http://localhost:3000');
});
app.post('/login', (req, res) => {
  const { username, password } = req.body;

  const sql = `SELECT * FROM appuser WHERE username = ? AND password = ?`;
  db.query(sql, [username, password], (err, results) => {
    if (err) {
      console.error('Login error:', err);
      return res.status(500).json({ message: 'Database error' });
    }

    if (results.length === 0) {
      return res.status(401).json({ message: 'Invalid username or password' });
    }

    const user = results[0];

    if (user.role === 'pet_owner') {
      return res.status(200).json({
        message: 'Login successful',
        role: user.role,
        user: {
          username: user.username,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          password: user.password,
          address: user.address,
          phoneNumber: user.phoneNumber,
        }
      });
    } else {
      return res.status(403).json({ message: 'Only pet_owner can login here' });
    }
  });
});

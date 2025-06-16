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
app.listen(3000, '0.0.0.0', () => console.log("Server running on port 3000"));
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
//to fetch product
app.get('/product', (req, res) => {
  db.query('SELECT * FROM product', (err, results) => {
    if (err) {
      console.error('Error retrieving product:', err);
      return res.status(500).json({ message: 'Error retrieving product' });
    }

    res.json(results); // ✅ رجعي النتائج مباشرة
  });
});

app.post('/signupVet', (req, res) => {
  console.log('Received vet signup:', req.body);
  const { username, email, password, firstName, lastName, phoneNumber, role, address, specialization } = req.body;

  // Step 1: Insert into appuser
  const userSql = `
    INSERT INTO appuser (username, email, password, firstName, lastName, phoneNumber, role, address)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `;
  const userValues = [username, email, password, firstName, lastName, phoneNumber, role, address];

  console.log('Executing SQL:', userSql, 'with values:', userValues);

  db.query(userSql, userValues, (err, result) => {
    if (err) {
      console.error('Detailed appuser error:', {
        code: err.code,
        errno: err.errno,
        sqlMessage: err.sqlMessage,
        sqlState: err.sqlState,
        sql: err.sql
      });
      return res.status(500).json({ 
        message: 'Database error during vet signup (appuser)',
        error: err.sqlMessage || err.message,
        code: err.code
      });
    }

    const userId = result.insertId;
    console.log('Successfully inserted user with ID:', userId);

    // Step 2: Insert into vet table
    const vetSql = `
      INSERT INTO vet (userID, specialization)
      VALUES (?, ?)
    `;
    const vetValues = [userId, specialization];

    console.log('Executing vet SQL:', vetSql, 'with values:', vetValues);

    db.query(vetSql, vetValues, (err2, result2) => {
      if (err2) {
        console.error('Detailed vet error:', {
          code: err2.code,
          errno: err2.errno,
          sqlMessage: err2.sqlMessage,
          sqlState: err2.sqlState,
          sql: err2.sql
        });
        return res.status(500).json({ 
          message: 'Database error during vet signup (vet)',
          error: err2.sqlMessage || err2.message,
          code: err2.code
        });
      }

      console.log('Successfully inserted vet with userID:', userId);
      res.status(200).json({ 
        message: 'Vet registered successfully',
        userId: userId 
      });
    });
  });
});
const mysql = require('mysql');

const db = mysql.createConnection({
  host: 'localhost',
  port: 3306,      
  user: 'root',
  password: '', 
  database: 'pawpress', //databse name
});

db.connect(err => {
  if (err) throw err;
  console.log('Connected to MySQL');
});

module.exports = db;
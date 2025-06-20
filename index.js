const express = require('express');
const cors = require('cors');
const db = require('./db');
const multer = require('multer');
const path = require('path');
const app = express();
const axios = require('axios');

app.use(cors());
app.use(express.json());

// تعريف الراوترات مثل /login هنا

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

// Serve uploaded files statically (اختياري لو بدك تعرض الصور لاحقاً)
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// ======= Sign up =======
app.post('/signup', (req, res) => {
  console.log('Received signup data:', req.body);
  const { username, email, password, firstName, lastName, phoneNumber, role, address } = req.body;
  const sql = `INSERT INTO appuser (username, email, password, firstName, lastName, phoneNumber, role, address)
               VALUES (?, ?, ?, ?, ?, ?, ?, ?)`;
  db.query(sql, [username, email, password, firstName, lastName, phoneNumber, role, address], (err, result) => {
    if (err) {
      console.error('Error during registration:', err);
      return res.status(500).json({ message: 'Database error' });
    }
    res.status(200).json({ message: 'User registered successfully' });
  });
});

// ======= Login =======
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

    // رجع البيانات حسب الدور
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
        userID: user.userID, // Include userID in the response
      }
    });
  });
});


// ======= Fetch Products =======
app.get('/product', (req, res) => {
  db.query('SELECT * FROM product', (err, results) => {
    if (err) {
      console.error('Error retrieving product:', err);
      return res.status(500).json({ message: 'Error retrieving product' });
    }
    res.json(results);
  });
});

// ======= Multer config for file upload =======
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}-${file.originalname}`);
  }
});
const upload = multer({ storage });

// ======= Add Pet =======
app.post('/addpet', upload.fields([
  { name: 'image', maxCount: 1 },
  { name: 'health_record_path', maxCount: 1 }
]), (req, res) => {
  const { name, age, breed, gender, userID } = req.body;
  const imagePath = req.files['image'] ? req.files['image'][0].path : null;
  const healthRecordPath = req.files['health_record_path'] ? req.files['health_record_path'][0].path : null;

  const sql = `INSERT INTO pet (userID, name, age, breed, gender, image, health_record_path)
               VALUES (?,?,?,?,?,?,?);`;

  db.query(sql, [userID, name, age, breed, gender, imagePath, healthRecordPath], (err, result) => {
    if (err) {
    console.error('#######Error adding pet######:', err);
    return res.status(500).json({ message: 'Database error', error: err.message }); // أرسل رسالة الخطأ
  }
  res.status(200).json({ message: 'Pet added successfully' });
});
});

// ======= Get Pets =======
app.post('/getpets', (req, res) => {
  const { userID } = req.body;

  const sql = `SELECT * FROM pet WHERE userID = ?`;
  db.query(sql, [userID], (err, results) => {
    if (err) {
      console.error('Error fetching pets:', err);
      return res.status(500).json({ message: 'Database error', error: err.message });
    }

    res.status(200).json(results);
  });
});

// ======= Fetch Pet Details =======
app.post('/getpetdetails', (req, res) => {
  const { petID } = req.body;

  if (!petID) {
    return res.status(400).json({ message: 'Pet ID is required' });
  }

  const sql = 'SELECT * FROM pet WHERE petID = ?';
  db.query(sql, [petID], (err, results) => {
    if (err) {
      console.error('Error retrieving pet details:', err);
      return res.status(500).json({ message: 'Error retrieving pet details' });
    }

    if (results.length === 0) {
      return res.status(404).json({ message: 'Pet not found' });
    }

    res.json(results[0]);
  });
});

// ======= Adoption =======
app.post('/adoption', (req, res) => {
  const { userID, petID, delivery_method, location, meeting_date, status } = req.body;

  if (!userID || !petID || !delivery_method || !location || !meeting_date || !status) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  const sql = `INSERT INTO adoption (userID, petID, delivery_method, location, meeting_date, status)
               VALUES (?, ?, ?, ?, ?, ?)`;

  db.query(sql, [userID, petID, delivery_method, location, meeting_date, status], (err, result) => {
    if (err) {
      console.error('Error saving adoption details:', err);
      return res.status(500).json({ message: 'Database error', error: err.message });
    }

    res.status(200).json({ message: 'Adoption details saved successfully' });
  });
});

// ======= Get User Details =======
app.post('/getuserdetails', (req, res) => {
  const { userID } = req.body;
  console.log('########Received userID:', userID); // ✅ Log userID

  const sql = `SELECT firstName, lastName, address, email, phoneNumber FROM appuser WHERE userID = ?`;
  db.query(sql, [userID], (err, results) => {
    if (err) {
      console.error('Error fetching user details:', err);
      return res.status(500).json({ message: 'Database error' });
    }

    if (results.length === 0) {
      return res.status(404).json({ message: 'User not found' });
    }

    const user = results[0];
    res.status(200).json({
      firstName: user.firstName,
      lastName: user.lastName,
      address: user.address,
      email: user.email,
      phoneNumber: user.phoneNumber
    });
  });
});
app.get('/test', (req, res) => {
  res.send('Test route works!');
});

// ======= Adoption Place =======
app.get('/adoptionplace', (req, res) => {
  const sql = `
    SELECT 
      adoption.petID, 
      adoption.userID, 
      pet.image, 
      pet.name AS petName, 
      appuser.firstName AS userName
    FROM adoption
    JOIN pet ON adoption.petID = pet.petID
    JOIN appuser ON adoption.userID = appuser.userID`;

  db.query(sql, (err, results) => {
    if (err) {
      console.error('Error fetching adoption place data:', err);
      return res.status(500).json({ message: 'Database error', error: err.message });
    }

    res.status(200).json(results);
  });
});

// ======= Fetch Pet Details by petID =======
app.post('/getAdoptionDetails', (req, res) => {
  const { petID } = req.body;

  if (!petID) {
    return res.status(400).json({ message: 'Pet ID is required' });
  }

  const sql = `
    SELECT 
      adoption.petID, 
      adoption.userID, 
      pet.name AS petName, 
      pet.breed, 
      pet.age, 
      pet.gender, 
      pet.image, 
      pet.health_record_path,
      appuser.firstName AS ownerFirstName, 
      appuser.lastName AS ownerLastName, 
      appuser.email AS ownerEmail, 
      appuser.phoneNumber AS ownerPhoneNumber, 
      adoption.delivery_method, 
      adoption.location, 
      adoption.meeting_date,
      adoption.status
    FROM adoption
    JOIN pet ON adoption.petID = pet.petID
    JOIN appuser ON adoption.userID = appuser.userID
    WHERE adoption.petID = ?`;

  db.query(sql, [petID], (err, results) => {
    if (err) {
      console.error('Error fetching adoption details:', err);
      return res.status(500).json({ message: 'Database error', error: err.message });
    }

    if (results.length === 0) {
      return res.status(404).json({ message: 'No adoption details found for the given Pet ID' });
    }

    res.status(200).json(results[0]);
  });
});

// ======= Clinics Endpoint =======
app.post('/clinics', (req, res) => {
  const { latitude, longitude } = req.body;

  const sql = `SELECT id, name, address, phone, latitude, longitude, image_url FROM clinics`;
  db.query(sql, (err, results) => {
    if (err) {
      console.error('Error fetching clinics:', err);
      return res.status(500).json({ message: 'Database error', error: err.message });
    }

    const haversine = (lat1, lon1, lat2, lon2) => {
      const toRad = (value) => (value * Math.PI) / 180;
      const R = 6371;
      const dLat = toRad(lat2 - lat1);
      const dLon = toRad(lon2 - lon1);
      const a =
        Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *
        Math.sin(dLon / 2) * Math.sin(dLon / 2);
      const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
      return R * c;
    };

    const clinicsWithDistance = results.map((clinic) => {
      const distance = haversine(
        parseFloat(latitude),
        parseFloat(longitude),
        parseFloat(clinic.latitude),
        parseFloat(clinic.longitude)
      );
      return { ...clinic, distance };
    });

    clinicsWithDistance.sort((a, b) => a.distance - b.distance);

    res.status(200).json(clinicsWithDistance);
  });
});

// ======= Add to Cart =======
app.post('/addToCart', (req, res) => {
  const { userID, productID, quantity } = req.body;

  // أولًا: نفحص إذا المنتج موجود بالكارت
  const checkSql = `SELECT * FROM cart2 WHERE userID = ? AND productID = ?`;
  db.query(checkSql, [userID, productID], (err, results) => {
    if (err) {
      console.error('Error checking cart:', err);
      return res.status(500).json({ message: 'Database error' });
    }

    if (results.length > 0) {
      // ✅ المنتج موجود → نحدث الكمية
      const newQuantity = results[0].quantity + quantity;
      const updateSql = `UPDATE cart2 SET quantity = ? WHERE userID = ? AND productID = ?`;
      db.query(updateSql, [newQuantity, userID, productID], (err, updateResult) => {
        if (err) {
          console.error('Error updating cart quantity:', err);
          return res.status(500).json({ message: 'Database error' });
        }
        return res.status(200).json({ message: 'Cart quantity updated successfully' });
      });
    } else {
      // ✅ المنتج مش موجود → نضيفه
      const insertSql = `INSERT INTO cart2 (userID, productID, quantity) VALUES (?, ?, ?)`;
      db.query(insertSql, [userID, productID, quantity], (err, insertResult) => {
        if (err) {
          console.error('Error inserting into cart:', err);
          return res.status(500).json({ message: 'Database error' });
        }
        return res.status(200).json({ message: 'Product added to cart successfully' });
      });
    }
  });
});

// ======= Get User Cart =======
app.post('/getUserCart', (req, res) => {
  const { userID } = req.body;

  const sql = `
    SELECT 
      cart2.productID,
      cart2.quantity,
      product.name,
      product.description,
      product.price
    FROM cart2
    JOIN product ON cart2.productID = product.productID
    WHERE cart2.userID = ?
  `;

  db.query(sql, [userID], (err, results) => {
    if (err) {
      console.error("Error fetching user cart:", err);
      return res.status(500).json({ error: "Database error" });
    }
    res.status(200).json(results);
  });
});
app.post('/removeFromCart', (req, res) => {
  const { userID, productID } = req.body;

  const sql = 'DELETE FROM cart2 WHERE userID = ? AND productID = ?';
  db.query(sql, [userID, productID], (err, result) => {
    if (err) {
      console.error('Error removing item from cart:', err);
      return res.status(500).json({ message: 'Database error' });
    }
    res.status(200).json({ message: 'Item removed successfully' });
  });
});


//==sign up vet==
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
// PayPal sandbox credentials
const PAYPAL_CLIENT_ID = 'AdjPCgjnKsG6A5bMeZHerGeK5QnkH_2qwQ3aNeM-GmOWkducueZBWwUzbPwdS6CQ_SsYyRvO4DSZRY6J';
const PAYPAL_SECRET = 'EPVMgP7kpKhx-PBWlI8s-etuvQDmM1SOe8QcUe4xQvoQK9cx2Y3Tjx7Zx8iRFNB8cJYqHHUDAxwBAghl';

// Get PayPal Access Token
async function getAccessToken() {
  const response = await axios({
    url: 'https://api-m.sandbox.paypal.com/v1/oauth2/token',
    method: 'post',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    auth: {
      username: PAYPAL_CLIENT_ID,
      password: PAYPAL_SECRET,
    },
    data: 'grant_type=client_credentials',
  });
  return response.data.access_token;
}

// Create PayPal Order
app.post('/create-paypal-order', async (req, res) => {
  const { amount, return_url, cancel_url } = req.body;

  try {
  const accessToken = await getAccessToken(); // ✅ لازم نجيبه من الدالة

  const response = await axios.post(
    'https://api-m.sandbox.paypal.com/v2/checkout/orders',
    {
      intent: 'CAPTURE',
      purchase_units: [{
        amount: {
          currency_code: 'USD',
          value: amount
        }
      }],
      application_context: {
        return_url: "myapp://paypal-success",
        cancel_url: "myapp://paypal-cancel"
      }
    },
    {
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${accessToken}`
      }
    }
  );


    const approvalLink = response.data.links.find(link => link.rel === 'approve');
    res.json({ link: approvalLink.href });

  } catch (error) {
    console.error('PayPal error:', error);
    res.status(500).json({ error: 'PayPal request failed' });
  }
});
// coplete paypal order
app.post('/complete-order', async (req, res) => {
  const { userID, cartItems, totalPrice } = req.body;

  db.beginTransaction(err => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Transaction failed to start' });
    }

    const sqlInsertOrder = 'INSERT INTO ordertable (userID, totalPrice, orderStatus, created_at) VALUES (?, ?, ?, NOW())';
    db.query(sqlInsertOrder, [userID, totalPrice, 'pending'], (err, orderResult) => {
      if (err) {
        return db.rollback(() => {
          res.status(500).json({ error: err.message });
        });
      }

      const orderID = orderResult.insertId;

      const insertOrderProduct = (index) => {
        if (index >= cartItems.length) {
          // بعد ما نخلص من إدخال كل العناصر، نحذفهم من cart2
          const deleteCartItems = (i) => {
            if (i >= cartItems.length) {
              return db.commit(err => {
                if (err) {
                  return db.rollback(() => {
                    res.status(500).json({ error: err.message });
                  });
                }
                res.status(200).json({ message: 'Order completed and cart updated!' });
              });
            }

            const item = cartItems[i];
            const sqlDelete = 'DELETE FROM cart2 WHERE userID = ? AND productID = ?';
            db.query(sqlDelete, [userID, item.productID], (err) => {
              if (err) {
                return db.rollback(() => {
                  res.status(500).json({ error: 'Failed to delete from cart: ' + err.message });
                });
              }
              deleteCartItems(i + 1);
            });
          };

          return deleteCartItems(0);
        }

        const item = cartItems[index];

        const sqlUpdateQty = 'UPDATE product SET quantity = quantity - ? WHERE productID = ? AND quantity >= ?';
        db.query(sqlUpdateQty, [item.quantity, item.productID, item.quantity], (err, updateResult) => {
          if (err || updateResult.affectedRows === 0) {
            return db.rollback(() => {
              res.status(400).json({ error: `Insufficient quantity for productID ${item.productID}` });
            });
          }

          const sqlInsertOrderProduct = 'INSERT INTO orderproduct (orderID, productID, quantity, price) VALUES (?, ?, ?, ?)';
          db.query(sqlInsertOrderProduct, [orderID, item.productID, item.quantity, item.price], (err) => {
            if (err) {
              return db.rollback(() => {
                res.status(500).json({ error: err.message });
              });
            }
            insertOrderProduct(index + 1);
          });
        });
      };

      insertOrderProduct(0);
    });
  });
});

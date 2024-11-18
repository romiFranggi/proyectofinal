import { getConnection } from "../databases/connection.js";
import sql from "mssql";

export const getUsers = async (req, res) => {
  const pool = await getConnection();

  const result = await pool.request().query("SELECT * FROM Users");

  res.json(result.recordset);
};

export const getUser = async (req, res) => {
  try {
    const pool = await getConnection();
    const result = await pool
      .request()
      .input("id", sql.Int, req.params.id)
      .query("SELECT * FROM Users where UserId = @id");

    console.log(result);

    if (result.rowsAffected[0] == 0) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json(result.recordset[0]);
  } catch (e) {
    return res.json({ message: e.message });
  }
};

export const postUser = async (req, res) => {
  try {
    const pool = await getConnection();
    const result = await pool
      .request()
      .input("userName", sql.NVarChar(50), req.body.UserName)
      .input("password", sql.NVarChar(255), req.body.Password)
      .input("email", sql.NVarChar(100), req.body.Email)
      .input("birthdate", sql.Date, req.body.Birthdate)
      .input("address", sql.NVarChar(255), req.body.Address)
      .input("rut", sql.NVarChar(20), req.body.RUT)
      .input("phone", sql.NVarChar(15), req.body.Phone)
      .input("contactName", sql.NVarChar(100), req.body.ContactName)
      .query(
        "INSERT INTO Users (UserName, Password, Email, Birthdate, Address, RUT, Phone, ContactName) VALUES (@userName, @password, @email, @birthdate, @address, @rut, @phone, @contactName); SELECT SCOPE_IDENTITY() AS Id"
      );

    console.log(result);

    res.json({
      Id: result.recordset[0].Id,
      UserName: req.body.UserName,
      Password: req.body.Password,
      Email: req.body.Email,
      Birthdate: req.body.Birthdate,
      Address: req.body.Address,
      RUT: req.body.RUT,
      Phone: req.body.Phone,
      ContactName: req.body.ContactName,
    });
  } catch (e) {
    return res.json({ message: e.message });
  }
};

export const putUser = async (req, res) => {
  try {
    const pool = await getConnection();
    const result = await pool
      .request()
      .input("userId", sql.Int, req.params.UserId)
      .input("userName", sql.NVarChar(50), req.body.UserName)
      .input("password", sql.NVarChar(255), req.body.Password)
      .input("email", sql.NVarChar(100), req.body.Email)
      .input("birthdate", sql.Date, req.body.Birthdate)
      .input("address", sql.NVarChar(255), req.body.Address)
      .input("rut", sql.NVarChar(20), req.body.RUT)
      .input("phone", sql.NVarChar(15), req.body.Phone)
      .input("contactName", sql.NVarChar(100), req.body.ContactName)
      .query(
        "UPDATE Users SET UserName = @userName, Password = @password, Email = @email, Birthdate = @birthdate, Address = @address, RUT = @rut, Phone = @phone, ContactName = @contactName WHERE Id = @id"
      );

    if (result.rowsAffected[0] == 0) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json({
      Id: req.params.id,
      UserName: req.body.UserName,
      Password: req.body.Price,
      Email: req.body.Email,
      Birthdate: req.body.Birthdate,
      Address: req.body.Address,
      RUT: req.body.RUT,
      Phone: req.body.Phone,
      ContactName: req.body.ContactName,
    });
  } catch (e) {
    return res.json({ message: e.message });
  }
};

export const deleteUser = async (req, res) => {
  try {
    const pool = await getConnection();
    const result = await pool
      .request()
      .input("id", sql.Int, req.params.id)
      .query("DELETE FROM Users WHERE UserId = @id");

    if (result.rowsAffected[0] == 0) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json({ message: "User deleted" });
  } catch (e) {
    return res.json({ message: e.message });
  }
};



//LOGIN
// Función de login para validar credenciales
export const loginUser = async (req, res) => {
  const { Email, Password } = req.body;
  
  try {
    const pool = await getConnection();
    const result = await pool
      .request()
      .input("Email", sql.NVarChar(100), Email)
      .input("Password", sql.NVarChar(255), Password)
      .query("SELECT * FROM Users WHERE Email = @Email AND Password = @Password");

    if (result.recordset.length > 0) {
      // Si el usuario existe y la contraseña es correcta
      console.log(result);
      res.json({
        codigo: 200,
        apiKey: "some-generated-api-key",  // O el token que generes
        email: Email,
        userName: result.recordset[0].UserName,
      });
    } else {
      // Si no se encuentran coincidencias
      res.status(401).json({
        codigo: 401,
        ok: false,
        message: "Credenciales incorrectas",
      });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({
      codigo: 500,
      message: "Error en el servidor",
    });
  }
};
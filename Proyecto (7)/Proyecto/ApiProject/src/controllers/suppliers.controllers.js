import { getConnection } from "../databases/connection.js";
import sql from "mssql";

export const getSuppliers = async (req, res) => {
  try {
    const pool = await getConnection();

    const result = await pool.request().query("SELECT * FROM Suppliers");

    res.json(result.recordset);
  } catch (e) {
    return res.json({ message: e.message });
  }
};

export const getSupplier = async (req, res) => {
  try {
    const pool = await getConnection();
    const result = await pool
      .request()
      .input("id", sql.Int, req.params.id)
      .query("SELECT * FROM Suppliers where SupplierId = @id");

    console.log(result);

    if (result.rowsAffected[0] == 0) {
      return res.status(404).json({ message: "Supplier not found" });
    }

    res.json(result.recordset[0]);
  } catch (e) {
    return res.json({ message: e.message });
  }
};

export const postSupplier = async (req, res) => {
  try {
    const pool = await getConnection();
    const result = await pool
      .request()
      .input("name", sql.NVarChar(100), req.body.Name)
      .input("phone", sql.NVarChar(15), req.body.Phone)
      .input("productId", sql.Int, req.body.ProductId)
      .input("cost", sql.Decimal(18, 2), req.body.Cost)
      .input("email", sql.NVarChar(100), req.body.Email)
      .input("lastPurchaseDate", sql.Date, req.body.LastPurchaseDate)
      .query(
        "INSERT INTO Suppliers (Name, Phone, ProductId, Cost, Email,LastPurchaseDate) VALUES (@name, @Phone, @ProductId, @Cost, @Email, @LastPurchaseDate); SELECT SCOPE_IDENTITY() AS SupplierId"
      );

    console.log(result);

    res.json({
      SupplierId: result.recordset[0].SupplierId,
      Name: req.body.Name,
      Phone: req.body.Phone,
      ProductId: req.body.ProductId,
      Cost: req.body.Cost,
      Email: req.body.Email,
      LastPurchaseDate: req.body.LastPurchaseDate,
    });
  } catch (e) {
    return res.json({ message: e.message });
  }
};

export const putSupplier = async (req, res) => {
  try {
    const pool = await getConnection();
    const result = await pool
      .request()
      .input("id", sql.Int, req.params.id)
      .input("name", sql.NVarChar(100), req.body.Name)
      .input("phone", sql.NVarChar(15), req.body.Phone)
      .input("productId", sql.Int, req.body.ProductId)
      .input("cost", sql.Decimal(18, 2), req.body.Cost)
      .input("email", sql.NVarChar(100), req.body.Email)
      .input("lastPurchaseDate", sql.Date, req.body.LastPurchaseDate)
      .query(
        "UPDATE Suppliers SET Name = @name, Phone = @phone, ProductId = @productId, Cost = @cost, Email = @email, LastPurchaseDate = @lastPurchaseDate WHERE SupplierId = @id"
      );

    if (result.rowsAffected[0] == 0) {
      return res.status(404).json({ message: "Supplier not found" });
    }

    res.json({
      SupplierId: req.params.id,
      Name: req.body.Name,
      Phone: req.body.Phone,
      ProductId: req.body.ProductId,
      Cost: req.body.Cost,
      Email: req.body.Email,
      LastPurchaseDate: req.body.LastPurchaseDate,
    });
  } catch (e) {
    return res.json({ message: e.message });
  }
};

export const deleteSupplier = async (req, res) => {
  try {
    const pool = await getConnection();
    const result = await pool
      .request()
      .input("id", sql.Int, req.params.id)
      .query("DELETE FROM Suppliers WHERE SupplierId = @id");

    if (result.rowsAffected[0] == 0) {
      return res.status(404).json({ message: "Supplier not found" });
    }

    res.json({ message: "Supplier deleted" });
  } catch (e) {
    return res.json({ message: e.message });
  }
};

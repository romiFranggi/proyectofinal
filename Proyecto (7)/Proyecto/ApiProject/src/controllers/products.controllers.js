import { getConnection } from "../databases/connection.js";
import sql from "mssql";

export const getProducts = async (req, res) => {
  try {
    const pool = await getConnection();

    const result = await pool.request().query("SELECT * FROM Products");

    res.json(result.recordset);
  } catch (e) {
    return res.json({ message: e.message });
  }
};

export const getProductsPerCategory = async (req, res) => {
  try{
    const pool = await getConnection();
    
    const result = await pool.request()
    .input("id", sql.Int, req.params.idCategory)
    .query("SELECT * FROM Products WHERE CategoryId = @id");

    res.json(result.recordset);

  } catch (e) {
    return res.json({ message: e.message });
  }
}

export const getProductsPerName = async (req, res) => {
  try{
    const pool = await getConnection();
    
    const result = await pool.request()
    .input("name", sql.VarChar, req.params.NameProduct)
    .query("SELECT * FROM Products WHERE Name = @name");

    res.json(result.recordset);

  } catch (e) {
    return res.json({ message: e.message });
  }
}

export const getProduct = async (req, res) => {
  try {
    const pool = await getConnection();
    const result = await pool
      .request()
      .input("id", sql.Int, req.params.id)
      .query("SELECT * FROM Products where ProductId = @id");

    console.log(result);

    if (result.rowsAffected[0] == 0) {
      return res.status(404).json({ message: "Product not found" });
    }

    res.json(result.recordset[0]);
  } catch (e) {
    return res.json({ message: e.message });
  }
};

export const postProduct = async (req, res) => {
  try {
    const pool = await getConnection();
    const result = await pool
      .request()
      .input("name", sql.NVarChar(100), req.body.Name)
      .input("price", sql.Decimal(18, 2), req.body.Price)
      .input("description", sql.NVarChar(255), req.body.Description)
      .input("quantity", sql.Int, req.body.Quantity)
      .input("creationDate", sql.DateTime, req.body.CreationDate)
      .query(
        "INSERT INTO Products (Name, Price, Description, Quantity, CreationDate) VALUES (@name, @price, @description, @quantity, @creationDate); SELECT SCOPE_IDENTITY() AS Id"
      );

    console.log(result);

    res.json({
      Id: result.recordset[0].Id,
      Name: req.body.Name,
      Price: req.body.Price,
      Description: req.body.Description,
      Quantity: req.body.Quantity,
      CreationDate: req.body.CreationDate,
    });
  } catch (e) {
    return res.json({ message: e.message });
  }
};

export const putProduct = async (req, res) => {
  try {
    const pool = await getConnection();
    const result = await pool
      .request()
      .input("id", sql.Int, req.params.id)
      .input("name", sql.NVarChar(100), req.body.Name)
      .input("price", sql.Decimal(18, 2), req.body.Price)
      .input("description", sql.NVarChar(255), req.body.Description)
      .input("quantity", sql.Int, req.body.Quantity)
      .input("creationDate", sql.DateTime, req.body.CreationDate)
      .query(
        "UPDATE Products SET Name = @name, Price = @price, Description = @description, Quantity = @quantity, CreationDate = @creationDate WHERE ProductId = @id"
      );

    if (result.rowsAffected[0] == 0) {
      return res.status(404).json({ message: "Product not found" });
    }

    res.json({
      ProductId: result.recordset[0].ProductId,
      Name: req.body.Name,
      Price: req.body.Price,
      Description: req.body.Description,
      Quantity: req.body.Quantity,
      CreationDate: req.body.CreationDate,
    });
  } catch (e) {
    return res.json({ message: e.message });
  }
};

export const deleteProduct = async (req, res) => {
  try {
    const pool = await getConnection();
    const result = await pool
      .request()
      .input("id", sql.Int, req.params.id)
      .query("DELETE FROM Products WHERE ProductId = @id");

    if (result.rowsAffected[0] == 0) {
      return res.status(404).json({ message: "Product not found" });
    }

    res.json({ message: "Product deleted" });
  } catch (e) {
    return res.json({ message: e.message });
  }
};


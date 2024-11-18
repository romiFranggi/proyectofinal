import { Router } from "express";
import {
  getProducts,
  getProductsPerCategory,
  getProduct,
  postProduct,
  putProduct,
  deleteProduct,
  getProductsPerName,
} from "../controllers/products.controllers.js";
const router = Router();

//#region Productos
router.get("/productos", getProducts);

router.get("/productos/categorias/:idCategory", getProductsPerCategory)

router.get("/productos/nombre/:NameProduct", getProductsPerName)

router.get("/productos/:id", getProduct);

router.post("/productos", postProduct);

router.put("/productos/:id", putProduct);

router.delete("/productos/:id", deleteProduct);
//#endregion

export default router;

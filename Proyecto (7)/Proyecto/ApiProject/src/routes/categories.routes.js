import { Router } from "express";
import {
  getCategories,
  getCategory,
  postCategory,
  putCategory,
  deleteCategory,
} from "../controllers/categories.controllers.js";
const router = Router();

//#region categorias
router.get("/categorias", getCategories);

router.get("/categorias/:id", getCategory);

router.post("/categorias", postCategory);

router.put("/categorias/:id", putCategory);

router.delete("/categorias/:id", deleteCategory);
//#endregion

export default router;

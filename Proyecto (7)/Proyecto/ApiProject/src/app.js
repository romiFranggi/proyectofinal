import express from 'express';
import productRoutes from './routes/products.routes.js';
import userRoutes from './routes/users.routes.js';
import categoriesRoutes from './routes/categories.routes.js';
import suppliersRoutes from './routes/suppliers.routes.js';
import { loginUser, postUser } from "./controllers/usersController.js"; 

const app = express();
app.use(express.json());

app.use(productRoutes, userRoutes, categoriesRoutes, suppliersRoutes);
app.post("/login", loginUser);


export default app;
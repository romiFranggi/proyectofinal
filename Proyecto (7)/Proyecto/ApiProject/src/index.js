import express from 'express';
import { PORT } from './config.js';
import productRoutes from './routes/products.routes.js';
import userRoutes from './routes/users.routes.js';
import categoriesRoutes from './routes/categories.routes.js';
import suppliersRoutes from './routes/suppliers.routes.js'
import cors from 'cors';

const app = express();
app.use(cors());
app.use(express.json());

app.use(productRoutes, userRoutes, categoriesRoutes, suppliersRoutes);

app.listen(PORT);
console.log('servidor iniciado... Puerto: ', PORT);

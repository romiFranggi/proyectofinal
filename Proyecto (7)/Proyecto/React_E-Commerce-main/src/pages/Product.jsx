import React, { useEffect, useState } from "react";
import Skeleton from "react-loading-skeleton";
import { Link, useParams } from "react-router-dom";
import Marquee from "react-fast-marquee";
import { useDispatch } from "react-redux";
import { addCart } from "../redux/action";
import axios from "axios";
import API_URL from "../config";
import toast from "react-hot-toast";

import "../css/productDetailPage.css";
import { Footer, Navbar } from "../components";

const Product = () => {
  const { id } = useParams(); // Obtiene el ID del producto desde la URL
  const [product, setProduct] = useState([]);
  const [category, setCategory] = useState([]);
  const [similarProducts, setSimilarProducts] = useState([]);
  const [relatedProducts, setRelatedProducts] = useState([]);
  const [loading, setLoading] = useState(false);
  const [loading2, setLoading2] = useState(false);

  const dispatch = useDispatch();

  const addProduct = (product) => {
    dispatch(addCart(product));
  };

  useEffect(() => {
    const getProduct = async () => {
      setLoading(true);
      setLoading2(true);

      try {
        // Obtener el producto específico por ID usando el ID de useParams
        const response = await axios.get(`${API_URL}/productos/${id}`);
        setProduct(response.data);

        // Obtener categoría del producto
        const responseCat = await axios.get(
          `${API_URL}/categorias/${response.data.CategoryId}`
        );
        setCategory(responseCat.data);

        // Obtener productos con el mismo nombre para el selector de medidas
        const relatedResponse = await axios.get(
          `${API_URL}/productos/nombre/${response.data.Name}`
        );
        setRelatedProducts(relatedResponse.data);

        // Obtener productos similares por categoría
        const response2 = await axios.get(
          `${API_URL}/productos/categorias/${response.data.CategoryId}`
        );

        const uniqueProducts = response2.data.reduce((acc, product) => {
          if (!acc.some((item) => item.Name === product.Name)) {
            acc.push(product);
          }
          return acc;
        }, []);

        setSimilarProducts(uniqueProducts);
      } catch (error) {
        console.error("Error encontrando información del producto", error);
      } finally {
        setLoading(false);
        setLoading2(false);
      }
    };

    getProduct();
  }, [id]); // Usa `id` como dependencia para actualizar el producto al cambiar la URL

  const handleSelectChange = (e) => {
    // Actualiza la URL directamente para cambiar el producto
    window.location.href = `/productos/${e.target.value}`;
  };

  const Loading = () => (
    <div className="container my-5 py-2">
      <div className="row">
        <div className="col-md-6 py-3">
          <Skeleton height={400} width={400} />
        </div>
        <div className="col-md-6 py-5">
          <Skeleton height={30} width={250} />
          <Skeleton height={90} />
          <Skeleton height={40} width={70} />
          <Skeleton height={50} width={110} />
          <Skeleton height={120} />
          <Skeleton height={40} width={110} inline={true} />
          <Skeleton className="mx-3" height={40} width={110} />
        </div>
      </div>
    </div>
  );

  const ShowProduct = () => (
    <div className="container my-5 py-2">
      <div className="row">
        <div className="col-md-6 col-sm-12 py-3">
          <img
            className="img-fluid border border-black border-5 rounded"
            src={product.ImageUrl}
            alt={product.Name}
            width="400px"
            height="400px"
          />
        </div>
        <div className="col-md-6 py-5">
          <h4 className="text-uppercase text-muted">{category.Name}</h4>
          <h1 className="display-5">{product.Name}</h1>
          <p className="lead">
            {product.Rate} <i className="fa fa-star"></i>
          </p>
          <h3 className="display-6  my-4">${product.Price}</h3>
          <p className="lead">{product.Description}</p>

          {/* Selector de medidas */}
          {relatedProducts.length > 1 && (
            <>
              <label htmlFor="sizeSelect">Medidas disponibles:</label>
              <select
                id="sizeSelect"
                value={id}
                onChange={handleSelectChange}
                className="form-select my-3"
              >
                {relatedProducts.map((item) => (
                  <option key={item.ProductId} value={item.ProductId}>
                    {item.Base} x {item.Height} cm - ${item.Price}
                  </option>
                ))}
              </select>
            </>
          )}

          <button
            className="btn btn-outline-dark"
            onClick={() => {
              toast.success("Añadido al carrito");
              addProduct(product);
            }}
          >
            Agregar al carrito
          </button>
          <Link to="/cart" className="btn btn-dark mx-3">
            Ir al carrito
          </Link>
        </div>
      </div>
    </div>
  );

  const Loading2 = () => (
    <div className="my-4 py-4">
      <div className="d-flex">
        {[...Array(4)].map((_, i) => (
          <div key={i} className="mx-4">
            <Skeleton height={400} width={250} />
          </div>
        ))}
      </div>
    </div>
  );

  const ShowSimilarProduct = () => (
    <div className="py-4 my-4">
      <div className="d-flex">
        {similarProducts.map((item) => (
          <div key={item.ProductId} className="card mx-4 text-center">
            <img
              className="card-img-top p-3"
              src={item.ImageUrl}
              alt="Card"
              height={300}
              width={300}
            />
            <div className="card-body">
              <h5 className="card-title">{item.Name}</h5>
            </div>
            <div className="card-body">
              <Link
                to={`/productos/${item.ProductId}`}
                className="btn btn-dark m-1"
              >
                Mostrar
              </Link>
            </div>
          </div>
        ))}
      </div>
    </div>
  );

  return (
    <div className="productDetail">
      <Navbar />
      <div className="container">
        <div className="row">{loading ? <Loading /> : <ShowProduct />}</div>
        <div className="row my-5 py-5">
          <div className="d-none d-md-block">
            <h2 className="">También te podría interesar</h2>
            <Marquee pauseOnHover={true} pauseOnClick={true} speed={50}>
              {loading2 ? <Loading2 /> : <ShowSimilarProduct />}
            </Marquee>
          </div>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default Product;

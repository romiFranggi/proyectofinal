import React, { useState, useEffect } from "react";

import Skeleton from "react-loading-skeleton";
import "react-loading-skeleton/dist/skeleton.css";
import "../css/productsHome.css";

import { Link } from "react-router-dom";
import axios from "axios";
import API_URL from "../config";

let componentMounted = true;
const Products = () => {
  const [data, setData] = useState([]);
  const [filter, setFilter] = useState(data);
  const [loading, setLoading] = useState(false);
  const [selectedCategory, setSelectedCategory] = useState(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [productsPerPage] = useState(6); // Número de productos por página

  useEffect(() => {
    const getProducts = async () => {
      setLoading(true);
      try {
        const response = await axios.get(`${API_URL}/productos`);
        if (componentMounted) {
          // Agrupar productos por 'Name' para mostrar solo uno de cada tipo
          const uniqueProducts = response.data.reduce((acc, product) => {
            if (!acc.some((item) => item.Name === product.Name)) {
              acc.push(product);
            }
            return acc;
          }, []);

          setData(uniqueProducts);
          setFilter(uniqueProducts);
          setLoading(false);
        }
      } catch (error) {
        console.error("Error en encontrar el producto:", error);
      }

      return () => {
        componentMounted = false;
      };
    };

    getProducts();
  }, []);

  const Loading = () => {
    return (
      <>
        <div className="col-12 py-5 text-center">
          <Skeleton height={40} width={560} />
        </div>
        <div className="col-md-4 col-sm-6 col-xs-8 col-12 mb-4">
          <Skeleton height={592} />
        </div>
      </>
    );
  };

  const filterProduct = (cat) => {
    const updatedList = data.filter((item) => item.CategoryId === cat);
    setFilter(updatedList);
    setCurrentPage(1);
    setSelectedCategory(cat);
  };

  const ShowProducts = () => {
    // Cálculo de los productos que deben ser mostrados según la página
    const indexOfLastProduct = currentPage * productsPerPage;
    const indexOfFirstProduct = indexOfLastProduct - productsPerPage;
    const currentProducts = filter.slice(
      indexOfFirstProduct,
      indexOfLastProduct
    );

    const totalPages = Math.ceil(filter.length / productsPerPage);

    return (
      <>
        <div className="buttons text-center py-5">
          <button
            className={`btn btn-outline-dark btn-sm m-2 ${
              selectedCategory === null ? "active" : ""
            }`}
            onClick={() => {
              setFilter(data);
              setSelectedCategory(null);
              setCurrentPage(1);
            }}
          >
            All
          </button>
          <button
            className={`btn btn-outline-dark btn-sm m-2 ${
              selectedCategory === 1 ? "active" : ""
            }`}
            onClick={() => filterProduct(1)}
          >
            Velas
          </button>
          <button
            className={`btn btn-outline-dark btn-sm m-2 ${
              selectedCategory === 2 ? "active" : ""
            }`}
            onClick={() => filterProduct(2)}
          >
            Sahumerios
          </button>
          <button
            className={`btn btn-outline-dark btn-sm m-2 ${
              selectedCategory === 3 ? "active" : ""
            }`}
            onClick={() => filterProduct(3)}
          >
            Decoracion
          </button>
        </div>

        <div className="row">
          {currentProducts.map((product) => (
            <div
              id={product.ProductId}
              key={product.ProductId}
              className="col-md-4 col-sm-6 col-xs-8 col-12 mb-4"
            >
              <div className="card text-center h-100">
                <img
                  className="card-img-top p-3"
                  src={product.ImageUrl}
                  alt="Card"
                  height={300}
                />
                <div className="card-body">
                  <h5 className="card-title">{product.Name}</h5>
                  <p className="card-text">
                    {" "}
                    {product.Description.length > 50
                      ? product.Description.slice(0, 50) + "..."
                      : product.Description}
                  </p>
                </div>
                <ul className="list-group list-group-flush">
                  <li className="list-group-item lead">$ {product.Price}</li>
                </ul>
                <div className="card-body">
                  <Link
                    to={`/productos/${product.ProductId}`}
                    className="btn btn-dark m-1"
                  >
                    Mostrar
                  </Link>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Paginación */}
        <div className="pagination">
          <button
            onClick={() => setCurrentPage(1)}
            disabled={currentPage === 1}
          >
            <i className="fa fa-angle-double-left"></i>
          </button>
          <button
            onClick={() => setCurrentPage(currentPage - 1)}
            disabled={currentPage === 1}
          >
            <i className="fa fa-angle-left"></i>
          </button>
          <span className="m-2">{` ${currentPage} de ${totalPages} `}</span>
          <button
            onClick={() => setCurrentPage(currentPage + 1)}
            disabled={currentPage === totalPages}
          >
            <i className="fa fa-angle-right"></i>
          </button>
          <button
            onClick={() => setCurrentPage(totalPages)}
            disabled={currentPage === totalPages}
          >
            <i className="fa fa-angle-double-right"></i>
          </button>
        </div>
      </>
    );
  };

  return (
    <div className="container my-3 py-3">
      <div className="row">
        <div className="col-12">
          <h2 className="display-5 text-center">Productos</h2>
          <hr />
        </div>
      </div>
      <div className="row justify-content-center">
        {loading ? <Loading /> : <ShowProducts />}
      </div>
    </div>
  );
};

export default Products;

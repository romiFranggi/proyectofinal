import React, { useEffect, useState } from 'react';
import { NavLink } from 'react-router-dom';
import { useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import logoImg from '../imgs/logoDef.png';
import '../css/navbar.css';

const Navbar = () => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    const estaLogueado = localStorage.getItem("id");
    setIsAuthenticated(!!estaLogueado);
  }, []);

  const state = useSelector(state => state.handleCart);
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.removeItem("id");
    localStorage.clear();
    setIsAuthenticated(false);
    //window.location.reload();
    navigate('/login');
  };

  const isAdminLoggedIn = () => {
    const email = localStorage.getItem("email");  // Verifica que el email esté almacenado en localStorage
    return email === "admin@hotmail.com";
  };
  
  
  return (
    <nav className="navbar navbar-expand-lg py-3 sticky-top">
      <div className="container d-flex justify-content-between align-items-center">
        <div className="d-flex align-items-center">
          <NavLink className="navbar-brand fw-bold fs-4 px-2" to="/">
            <img src={logoImg} alt="Logo" className="navbar-logo img-fluid" />
          </NavLink>
        </div>
  
        <button className="navbar-toggler mx-2" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
          <span className="navbar-toggler-icon"></span>
        </button>
  
        <div className="collapse navbar-collapse" id="navbarSupportedContent">
          <ul className="navbar-nav m-auto my-2 text-center">
            <li className="nav-item">
              <NavLink className="nav-link" to="/">Inicio</NavLink>
            </li>
            <li className="nav-item">
              <NavLink className="nav-link" to="/productos">Productos</NavLink>
            </li>
            <li className="nav-item">
              <NavLink className="nav-link" to="/about">Sobre nosotros</NavLink>
            </li>
            <li className="nav-item">
              <NavLink className="nav-link" to="/contact">Contacto</NavLink>
            </li>
          </ul>
  
          <div className="buttons text-center">
            {isAuthenticated ? (
              <>
                {isAdminLoggedIn() ? (
                  <NavLink to="/Dashboard" className="btn btn-outline-dark m-2">
                    <i className="fa fa-sign-in-alt mr-1"></i> DashBoard
                  </NavLink>
                ) : null}
                <button className="btn btn-outline-dark m-2" onClick={handleLogout}>
                  <i className="fa fa-sign-out-alt mr-1"></i> Cerrar Sesion
                </button>
              </>
            ) : (
              <>
                <NavLink to="/login" className="btn btn-outline-dark m-2">
                  <i className="fa fa-sign-in-alt mr-1"></i> Ingresar
                </NavLink>
                <NavLink to="/register" className="btn btn-outline-dark m-2">
                  <i className="fa fa-user-plus mr-1"></i> Registrarse
                </NavLink>
              </>
            )}
            <NavLink to="/cart" className="btn btn-outline-dark m-2">
              <i className="fa fa-cart-shopping mr-1"></i> Carrito ({state.length})
            </NavLink>
          </div>
        </div>
      </div>
    </nav>
  );
}

export default Navbar;
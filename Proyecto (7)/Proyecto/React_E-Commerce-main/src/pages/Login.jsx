import React, { useRef } from 'react';
import { Footer, Navbar } from "../components";
import { Link, useNavigate } from 'react-router-dom';
import toast from "react-hot-toast";
import "../css/login.css";

const Login = () => {
  const Password = useRef(null);
  const Email = useRef(null);
  const navigate = useNavigate();

  const handleSubmit = (e) => {
    e.preventDefault();

    const emailValue = Email.current?.value;
    const passwordValue = Password.current?.value;

    if (!emailValue || !passwordValue) {
      toast.error("Todos los campos son obligatorios");
      return;
    }

    fetch("http://localhost:3000/login", {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        Email: emailValue,
        Password: passwordValue,
      }),
    })
      .then((response) => {
        if (!response.ok) {
          // Si no es 200 OK, lanza un error
          throw new Error("Error en la autenticación");
        }
        return response.json();
      })
      .then((json) => {
       // console.log(json);
        if (json.codigo === 200) {
          console.log(json);
          localStorage.setItem("id", json.apiKey);
          localStorage.setItem("email", json.email);
          localStorage.setItem("userName", json.userName);

          toast.success("Login realizado");
          navigate("/"); 
        } else {
          toast.error("Login no realizado");
        }
      })
      .catch((error) => {
        console.error("Error en la solicitud:", error);
        toast.error("Hubo un problema con el inicio de sesión. Intenta nuevamente.");
      });
  };

  return (
    <div className='loginPage'>
      <Navbar />
      <div className="container my-5 py-5">
        <h1 className="text-center">Login</h1>
        <hr />
        <div className="row my-4 h-100">
          <div className="col-md-4 col-lg-4 col-sm-8 mx-auto">
            <form onSubmit={handleSubmit}>
              <div className="my-3">
                <label htmlFor="display-4">Email</label>
                <input
                  type="email"
                  className="form-control"
                  id="floatingInput"
                  placeholder="name@example.com"
                  ref={Email}
                />
              </div>
              <div className="my-3">
                <label htmlFor="floatingPassword display-4">Contraseña</label>
                <input
                  type="password"
                  className="form-control"
                  id="floatingPassword"
                  placeholder="Password"
                  ref={Password}
                />
              </div>
              <div className="my-3">
                <p>¿Eres nuevo? <Link to="/register" className="text-decoration-underline text-info">Registrate</Link> </p>
              </div>
              <div className="text-center">
                <button className="my-2 mx-auto btn btn-dark" type="submit">
                  Login
                </button>

              </div>
            </form>
          </div>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default Login;
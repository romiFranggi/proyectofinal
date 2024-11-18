import React, { useRef } from 'react';
import { Footer, Navbar } from "../components";
import { Link, useNavigate } from 'react-router-dom';
import toast from "react-hot-toast";
import "../css/register.css";

const Register = () => {
    const UserName = useRef(null);
    const Password = useRef(null);
    const Email = useRef(null);
  
    const navigate = useNavigate();

    const handleSubmit = (e) => {
        e.preventDefault();
    
        const userNameValue = UserName.current?.value;
        const emailValue = Email.current?.value;
        const passwordValue = Password.current?.value;
    
        if (!userNameValue || !emailValue || !passwordValue) {
            toast.error("Todos los campos son obligatorios");
            return;
        }
    
        fetch("http://localhost:3000/usuarios", {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                UserName: userNameValue,
                Password: passwordValue,
                Email: emailValue,
            }),
        })
        .then(response => {
            if (response.ok) {
                toast.success("Registro realizado");
                navigate("/login");
                return response.json();
                
            } else {
                toast.error("Registro no realizado");
                throw new Error("Registro fallido");
            }
        })
        .then(datos => {
            //console.log(datos);
            // Navegar o realizar otras acciones después del registro
        })
        .catch(err => {
            console.error("Error en el registro:", err);
            toast.error("Ocurrió un error en el registro");
        });
    };

    return (
        <div className='registerPage'>
            <Navbar />
            <div className="container my-5 py-5">
                <h1 className="text-center">Registrarse</h1>
                <hr />
                <div className="row my-4 h-100">
                    <div className="col-md-4 col-lg-4 col-sm-8 mx-auto">
                        <form onSubmit={handleSubmit}>
                            <div className="form my-3">
                                <label htmlFor="Name">Nombre Completo</label>
                                <input
                                    type="text"
                                    className="form-control"
                                    id="Name"
                                    placeholder="Escribe tu nombre"
                                    ref={UserName}
                                />
                            </div>
                            <div className="form my-3">
                                <label htmlFor="Email">Email</label>
                                <input
                                    type="email"
                                    className="form-control"
                                    id="Email"
                                    placeholder="name@ejemplo.com"
                                    ref={Email}
                                />
                            </div>
                            <div className="form my-3">
                                <label htmlFor="Password">Contraseña</label>
                                <input
                                    type="password"
                                    className="form-control"
                                    id="Password"
                                    placeholder="Escribe tu contraseña"
                                    ref={Password}
                                />
                            </div>
                            <div className="my-3">
                                <p>¿Ya tienes una cuenta? <Link to="/login" className="text-decoration-underline text-info">Login</Link> </p>
                            </div>
                            <div className="text-center">
                                <button className="my-2 mx-auto btn btn-dark" type="submit">
                                    Registrate
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

export default Register;

/*try{
    const response = await fetch('http://localhost:3000/api/users', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(userData)
    });
}
catch(e){
    setMessage('Error en la conexión con el servidor');
}*/


  
      /* if(usuario === "a" && contra === "a"){
           localStorage.setItem("usuario", "a");
           navigate("/clima")
       }else{
           localStorage.clear();
           setError(true);
       }
     useEffect(() => {
       fetch("https://censo.develotion.com/usuarios.php")
           .then(r => r.json())
           .then(datos => {
             setUsuario(datos.result); //?
           })
    }, []);*/

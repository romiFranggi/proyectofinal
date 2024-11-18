import React, { useState } from "react";
import { NavLink } from 'react-router-dom';
import "bootstrap/dist/css/bootstrap.min.css";

const Sidebar = () => {
  const [activeSection, setActiveSection] = useState("Productos");

  const handleSectionChange = (section) => {
    setActiveSection(section);
  };

  return (
    <div className="d-flex">
      <div className="bg-black text-white vh-100 p-4" style={{ width: "190px" }}>
        <h4 className="text-white">Dashboard</h4>
        <ul className="nav flex-column">
        <li className="nav-item">
        <button
              className={`nav-link ${activeSection === "Productos" ? "active text-primary bg-white" : "text-white"}`}
              style={{ borderRadius: "8px" }}
              onClick={() => handleSectionChange("Productos")}>
              Productos
            </button>
            </li>
          <li className="nav-item">
            <button
              className={`nav-link ${activeSection === "Proveedores" ? "active text-primary bg-white" : "text-white"}`}
              style={{ borderRadius: "8px" }}
              onClick={() => handleSectionChange("Proveedores")}>
              Proveedores
            </button>
          </li>
        </ul>
      </div>
    </div>
  );
};

export default Sidebar;
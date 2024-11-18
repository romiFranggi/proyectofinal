// Retrieve initial state from localStorage if available
const getInitialCart = () => {
  const storedCart = localStorage.getItem("cart");
  return storedCart ? JSON.parse(storedCart) : [];
};

const handleCart = (state = getInitialCart(), action) => {
  const product = action.payload;
  let updatedCart;

  switch (action.type) {
    case "ADDITEM":
      // Check if product already in cart
      const exist = state.find((x) => x.ProductId === product.ProductId);
      if (exist) {
        // Increase the quantity
        updatedCart = state.map((x) =>
          x.ProductId === product.ProductId ? { ...x, qty: x.qty + 1 } : x
        );
      } else {
        updatedCart = [...state, { ...product, qty: 1 }];
      }
      // Update localStorage
      localStorage.setItem("cart", JSON.stringify(updatedCart));
      return updatedCart;

    case "DELITEM":
      const exist2 = state.find((x) => x.ProductId === product.ProductId);
      if (exist2.qty === 1) {
        updatedCart = state.filter((x) => x.ProductId !== exist2.ProductId);
      } else {
        updatedCart = state.map((x) =>
          x.ProductId === product.ProductId ? { ...x, qty: x.qty - 1 } : x
        );
      }
      // Update localStorage
      localStorage.setItem("cart", JSON.stringify(updatedCart));
      return updatedCart;

    default:
      return state;
  }
};

export default handleCart;

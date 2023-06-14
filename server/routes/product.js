const express = require('express');
const productRouter = express.Router();
const auth = require('../middleware/auth_middleware');
const {Product} = require("../model/product_model");

productRouter.get("/api/products", auth, async (req, res) => {
  try {
  console.log(req.query.category);
    const products = await Product.find({category: req.query.category});
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


//search products
//productRouter.get("/api/products/search/:name", auth, async (req, res) => {
//  try {
//    const products = await Product.find({name: { $regex: req.params.name, options: "i"},});
//    res.json(products);
//  } catch (e) {
//    res.status(500).json({ error: e.message });
//  }
//});
productRouter.get("/api/products/search/:name", auth, async (req, res) => {
  try {
    const regexPattern = new RegExp(req.params.name, "i");
    const products = await Product.find({ name: regexPattern });
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//crate a post request route to rate the products.
productRouter.post("/api/products/rate/:productId", auth, async (req, res) => {
  try {
    const { userId, rating } = req.body;
    const productId = req.params.productId;

    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ error: "Product not found" });
    }

    // Check if the user has already rated the product
    const existingRating = product.ratings.find(
      (rating) => rating.userId === userId
    );
    if (existingRating) {
      return res.status(400).json({ error: "You have already rated this product" });
    }

    // Add the new rating to the product's ratings array
    product.ratings.push({ userId, rating });
    await product.save();

    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//deal of the day

productRouter.get('/api/deal-of-day', auth, async (req, res) => {
    try{
        let products = await Product.find();
        products = products.sort((a, b) => {
            let aSum = 0;
            let bSum = 0;

            for (let i = 0; i< a.ratings.length; i++){
                aSum += a.ratings[i].rating;
            }

            for (let i = 0; i< b.ratings.length; i++){
                 bSum += b.ratings[i].rating;
            }

        return aSum < bSum ? 1 : -1;
        });
        res.json(products[0]);
    } catch (e){
        res.status(500).json({ error: e.message });
    }
});

module.exports = productRouter;

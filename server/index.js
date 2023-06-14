const express = require('express');
const mongoose = require('mongoose');

const authRouter = require("./routes/auth");
const adminRouter = require("./routes/admin");
const productRouter = require("./routes/product");
const userRouter = require("./routes/user");

const PORT = process.env.PORT || 3000;

const app = express();

const URL = "mongodb+srv://adhil:a4adhil@cluster0.emhvydh.mongodb.net/?retryWrites=true&w=majority";

app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);

mongoose.connect(URL).then(()=>{
    console.log("Connection Successful")
}).catch((e)=>{
    console.log(e);
});

app.listen(PORT, "0.0.0.0", ()=>{
    console.log(`connected at port ${PORT}`);
});
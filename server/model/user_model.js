const mongoose = require('mongoose');
const {productSchema} = require("./product_model");

const UserSchema = mongoose.Schema({
    name: {
        required: true,
        type: String,
        trim: true
    },
    email: {
        required: true,
        type: String,
        trim: true,
        validate: {
             validator: (value) => {
                        const re = /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                        return value.match(re);
                    },
                    message: "Please enter a valid email address",
        }
    },
    password: {
        required: true,
        type: String,
        validate:{
            validator: (value)=>{
                return value.length >6;
            },
            message: "Please enter a valid password",
        }
    },
    address: {
        type: String,
        default: ''
    },
    type: {
        type: String,
        default: 'user',
    },
    cart: [
        {
            product: productSchema,
            quantity: {
                type: Number,
                required: true,
            }
        }
    ]
});

const User = mongoose.model("User", UserSchema);
module.exports = User;
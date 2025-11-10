const mongoose = require("mongoose");

const tareasSchema = new mongoose.Schema({
    titulo : {
        type : String,
        required : true,
        trim: true,
        minlength: 3,
        maxlength: 100
    },
    descripcion: {
        type : String,
        required : true,
        trim : true,
        minlength : 3,
        maxlength : 500
    },
    prioridad:{
        type: String,
        enum: ['baja', 'media', 'alta'],
        default: 'otros',
        message: '{VALUE} no es una categoria valida'
    },
    categoria : {
        
    }
})
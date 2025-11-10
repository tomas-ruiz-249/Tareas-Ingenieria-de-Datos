const mongoose = require('mongoose');

const connectDb = async () => {
    try{
        const conn = await mongoose.connect(process.env.MONGO_URI);
        console.log(`mongodb connected: ${conn.connection.host}`);
    }
    catch(error){
        console.error("error a conectar a mongo", error)
        process.exit(1);
    }
}

mongoose.connection.on('disconnected', () => {
    console.log("Mongodb disconnected");
})
mongoose.connection.on('error', () => {
    console.log('mongodb connection error');
})

process.on("SIGINT", async () => {
    await mongoose.connection.close();
    console.log('mongodb disconnected through app termination')
    process.exit(0);
})
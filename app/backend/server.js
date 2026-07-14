const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const errorHandler = require("./middleware/errorMiddleware");
const helmet = require("helmet");
const morgan = require("morgan");
require("dotenv").config();

const app = express();

app.use(cors());
app.use(express.json());
app.use(helmet());
app.use(morgan("dev"));
// Routes
app.use("/api/users", require("./routes/userRoutes"));

app.get("/", (req, res) => {
  res.send("API Running...");
});

// DB Connection
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log("MongoDB Connected"))
  .catch(err => console.log(err));

// Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

app.use(errorHandler);
import { useEffect, useState } from "react";
import axios from "axios";

function App() {
  const [users, setUsers] = useState([]);
  const [name, setName] = useState("");

  const API = "/api/users";

  const fetchUsers = async () => {
    const res = await axios.get(API);
    setUsers(res.data);
  };

  const addUser = async () => {
    if (!name.trim()) return;
    await axios.post(API, { name });
    setName("");
    fetchUsers();
  };

  const deleteUser = async (id) => {
    await axios.delete(`${API}/${id}`);
    fetchUsers();
  };

  const clearInput = () => setName("");

  useEffect(() => {
    fetchUsers();
  }, []);

  return (
    <div style={styles.page}>
      <div style={styles.card}>
        <h1 style={styles.title}>User Manager</h1>

        <div style={styles.inputRow}>
          <input
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="Enter name..."
            style={styles.input}
          />

          <button onClick={addUser} style={styles.addBtn}>
            Add
          </button>

          <button onClick={clearInput} style={styles.clearBtn}>
            Clear
          </button>
        </div>

        <div style={styles.list}>
          {users.map((u) => (
            <div key={u._id} style={styles.userCard}>
              <span>{u.name}</span>
              <button
                onClick={() => deleteUser(u._id)}
                style={styles.deleteBtn}
              >
                ✕
              </button>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

const styles = {
  page: {
    minHeight: "100vh",
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    background: "linear-gradient(135deg, #667eea, #764ba2)",
    padding: "20px",
  },
  card: {
    background: "#fff",
    padding: "30px",
    borderRadius: "16px",
    width: "100%",
    maxWidth: "400px",
    boxShadow: "0 10px 30px rgba(0,0,0,0.2)",
  },
  title: {
    textAlign: "center",
    marginBottom: "20px",
  },
  inputRow: {
    display: "flex",
    gap: "10px",
    marginBottom: "20px",
  },
  input: {
    flex: 1,
    padding: "10px",
    borderRadius: "8px",
    border: "1px solid #ddd",
    outline: "none",
  },
  addBtn: {
    background: "#4CAF50",
    color: "white",
    border: "none",
    padding: "10px 14px",
    borderRadius: "8px",
    cursor: "pointer",
  },
  clearBtn: {
    background: "#f1f1f1",
    border: "none",
    padding: "10px 14px",
    borderRadius: "8px",
    cursor: "pointer",
  },
  list: {
    display: "flex",
    flexDirection: "column",
    gap: "10px",
  },
  userCard: {
    display: "flex",
    justifyContent: "space-between",
    alignItems: "center",
    padding: "10px",
    borderRadius: "8px",
    background: "#f9f9f9",
  },
  deleteBtn: {
    background: "#ff4d4f",
    color: "white",
    border: "none",
    padding: "6px 10px",
    borderRadius: "6px",
    cursor: "pointer",
  },
};

export default App;
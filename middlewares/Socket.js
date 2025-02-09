const fs = require("fs");
const path = require("path");
const chatFile = path.resolve(__dirname, "../database/chat.json");

function saveMessage(route, message) {
    let chats = {};

    if (fs.existsSync(chatFile)) {
        try {
            chats = JSON.parse(fs.readFileSync(chatFile, "utf8"));
        } catch (error) {
            console.error("Error parsing chat.json:", error);
            chats = {};
        }
    }

    if (!chats[route]) {
        chats[route] = [];
    }
    chats[route].push(message);

    try {
        fs.writeFileSync(chatFile, JSON.stringify(chats, null, 2));
    } catch (error) {
        console.error("Error writing to chat.json:", error);
    }
}

function setupSocket(server) {
    const io = require("socket.io")(server, {
        cors: { origin: "*" }
    });

    io.on("connection", (socket) => {
        let currentRoom = null;

        socket.on("join room", (route) => {
            if (currentRoom) {
                socket.leave(currentRoom);
            }
            currentRoom = route;
            socket.join(route);

            let chats = {};
            if (fs.existsSync(chatFile)) {
                chats = JSON.parse(fs.readFileSync(chatFile, "utf8"));
            }

            if (chats[route]) {
                socket.emit("chat history", chats[route]);
            }
        });

		socket.on("chat message", ({ route, text }) => {			
			if (!route || !text.trim()) return;

			const message = {
				text: text,
				timestamp: new Date().toISOString()
			};

			saveMessage(route, message);
			io.to(route).emit("chat message", message);
		});

        socket.on("disconnect", () => {
            if (currentRoom) {
                socket.leave(currentRoom);
            }
        });
    });
}

module.exports = { setupSocket };

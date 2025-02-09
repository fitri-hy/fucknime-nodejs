(function() {
    const chatContainer = document.createElement('div');
    chatContainer.innerHTML = `
        <div id="chatBox" class="fixed z-50 bottom-20 right-4 border border-gray-200 dark:border-neutral-600 w-full max-w-sm h-auto bg-white dark:bg-neutral-700 shadow-lg rounded overflow-hidden transform transition-all duration-300 opacity-0 pointer-events-none">
            <h2 id="chatRoomName" class="bg-gray-700 dark:bg-neutral-600 text-white p-3 font-bold truncate">💬 Ngobrol</h2>
            <div class="p-2 h-[350px] overflow-y-auto space-y-2" id="chatMessages"></div>
            <div class="p-2 flex gap-2">
                <input id="chatInput" type="text" placeholder="Apa yang mau diobrolin?..." maxlength="300" class="w-full p-2 rounded bg-white dark:bg-neutral-600 border border-gray-200 dark:border-neutral-500 focus:outline-none" required>
                <button id="chatSend" class="bg-gray-700 dark:bg-neutral-600 hover:bg-gray-800 hover:dark:bg-neutral-500 transition-all duration-300 hover:scale-105 text-white px-4 py-2 rounded">
					<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
					  <path stroke-linecap="round" stroke-linejoin="round" d="M6 12 3.269 3.125A59.769 59.769 0 0 1 21.485 12 59.768 59.768 0 0 1 3.27 20.875L5.999 12Zm0 0h7.5" />
					</svg>
				</button>
            </div>
        </div>

        <button id="chatToggle" class="fixed z-50 bottom-4 right-4 w-14 h-14 bg-gray-700 hover:bg-gray-800 dark:bg-neutral-600 hover:bg-neutral-500 text-white rounded-full flex items-center justify-center shadow-lg transition duration-300 hover:scale-105">
            <span id="chatToggleIcon">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M7.5 8.25h9m-9 3H12m-9.75 1.51c0 1.6 1.123 2.994 2.707 3.227 1.129.166 2.27.293 3.423.379.35.026.67.21.865.501L12 21l2.755-4.133a1.14 1.14 0 0 1 .865-.501 48.172 48.172 0 0 0 3.423-.379c1.584-.233 2.707-1.626 2.707-3.228V6.741c0-1.602-1.123-2.995-2.707-3.228A48.394 48.394 0 0 0 12 3c-2.392 0-4.744.175-7.043.513C3.373 3.746 2.25 5.14 2.25 6.741v6.018Z" />
                </svg>
            </span>
        </button>
    `;
    document.body.appendChild(chatContainer);

    const socket = io("http://localhost:3000", {
		transports: ["websocket"],
		upgrade: false
	});

    const route = window.location.pathname;

    socket.emit("join room", route);

    let formattedRoute = route
        .replace(/^\/+/, '')
        .replace(/^(anime\/|episode\/)/, '')
        .replace(/-/g, ' ')
        .toLowerCase()
        .replace(/\b\w/g, (char) => char.toUpperCase());

    document.getElementById("chatRoomName").textContent = `💬 Ngobrol ${formattedRoute}`;

	function escapeHTML(str) {
		const element = document.createElement('div');
		if (str) {
			element.innerText = str;
			element.textContent = str;
		}
		return element.innerHTML;
	}

	function displayMessage(msg, isOwnMessage = false) {
		const messages = document.getElementById("chatMessages");
		const messageElement = document.createElement("div");
		messageElement.classList.add("p-2", "rounded-lg", "text-white", "w-fit", "max-w-xs");

		if (isOwnMessage) {
			messageElement.classList.add("bg-blue-500", "ml-auto");
		} else {
			messageElement.classList.add("bg-gray-500", "mr-auto");
		}

		const time = new Date(msg.timestamp).toLocaleString("id-ID", {
			hour: "2-digit",
			minute: "2-digit",
			day: "2-digit",
			month: "2-digit",
			year: "numeric"
		});

		const safeText = escapeHTML(msg.text);

		messageElement.innerHTML = `<p>${safeText}</p><small class="block text-xs mt-1 opacity-70">${time}</small>`;
		messages.appendChild(messageElement);
		messages.scrollTop = messages.scrollHeight;
	}


    function sendMessage() {
        const input = document.getElementById("chatInput");
        if (input.value.trim() !== '') {
            const message = { route: route, text: input.value };
            socket.emit("chat message", message);
			displayMessage({ text: input.value, timestamp: new Date().toISOString() }, true);
            input.value = '';
        }
    }

    document.getElementById("chatSend").addEventListener("click", sendMessage);

    document.getElementById("chatInput").addEventListener("keypress", (e) => {
        if (e.key === "Enter") {
            sendMessage();
        }
    });

    socket.on("chat message", (msg) => {
        const lastMessage = document.getElementById("chatMessages").lastChild;
        if (lastMessage && lastMessage.textContent.includes(msg.text)) return;
        displayMessage(msg);
    });

    socket.on("chat history", (messages) => {
        messages.forEach(msg => {
            displayMessage(msg);
        });
    });

    const chatBox = document.getElementById("chatBox");
    const chatToggleButton = document.getElementById("chatToggle");

    chatToggleButton.addEventListener("click", () => {
        const chatToggleIcon = document.getElementById("chatToggleIcon");

        if (chatBox.classList.contains("opacity-0")) {
            chatBox.classList.remove("opacity-0", "pointer-events-none");
            chatBox.classList.add("opacity-100");
            chatToggleIcon.innerHTML = `
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
                </svg>
            `;
        } else {
            chatBox.classList.add("opacity-0", "pointer-events-none");
            chatBox.classList.remove("opacity-100");
            chatToggleIcon.innerHTML = `
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M7.5 8.25h9m-9 3H12m-9.75 1.51c0 1.6 1.123 2.994 2.707 3.227 1.129.166 2.27.293 3.423.379.35.026.67.21.865.501L12 21l2.755-4.133a1.14 1.14 0 0 1 .865-.501 48.172 48.172 0 0 0 3.423-.379c1.584-.233 2.707-1.626 2.707-3.228V6.741c0-1.602-1.123-2.995-2.707-3.228A48.394 48.394 0 0 0 12 3c-2.392 0-4.744.175-7.043.513C3.373 3.746 2.25 5.14 2.25 6.741v6.018Z" />
                </svg>
            `;
        }
    });
})();

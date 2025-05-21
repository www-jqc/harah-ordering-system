const WebSocket = require('ws');
const http = require('http');

// Create HTTP server
const server = http.createServer();

// Create WebSocket server
const wss = new WebSocket.Server({ server });

// Port configuration (can be changed)
const PORT = process.env.PORT || 8080;

// Store connected clients
const clients = new Set();

// WebSocket server connection handler
wss.on('connection', (ws) => {
  console.log('Client connected');
  clients.add(ws);
  
  // Send welcome message
  ws.send(JSON.stringify({
    type: 'connection',
    message: 'Connected to Harah WebSocket Server',
    timestamp: new Date().toISOString()
  }));
  
  // Handle messages from clients
  ws.on('message', (message) => {
    try {
      const data = JSON.parse(message);
      console.log('Received message:', data);
      
      // Broadcasting message to all connected clients
      if (data.type && data.broadcast === true) {
        broadcastMessage(data, ws);
      }
    } catch (e) {
      console.error('Error parsing message:', e);
    }
  });
  
  // Handle client disconnection
  ws.on('close', () => {
    console.log('Client disconnected');
    clients.delete(ws);
  });
  
  // Handle errors
  ws.on('error', (error) => {
    console.error('WebSocket error:', error);
    clients.delete(ws);
  });
});

// Function to broadcast messages to all connected clients
function broadcastMessage(data, sender = null) {
  const message = JSON.stringify({
    ...data,
    timestamp: new Date().toISOString()
  });
  
  clients.forEach((client) => {
    // Don't send the message back to the sender
    if (client !== sender && client.readyState === WebSocket.OPEN) {
      client.send(message);
    }
  });
}

// Server-side function to trigger events (can be called from your PHP backend)
function triggerEvent(eventType, message, data = {}) {
  const eventData = {
    type: eventType,
    message: message,
    data: data,
    timestamp: new Date().toISOString()
  };
  
  broadcastMessage(eventData);
}

// Start listening for HTTP requests
server.listen(PORT, () => {
  console.log(`WebSocket server is running on port ${PORT}`);
});

// Export for external use
module.exports = {
  triggerEvent
};

/*
 * Integration with your PHP backend:
 * 
 * 1. Install this as a Node.js service on your server
 * 2. From your PHP backend, you can notify this server using HTTP requests when events occur
 * 
 * Example HTTP call from PHP:
 * 
 * $data = [
 *   'type' => 'new_order',
 *   'message' => 'New order received',
 *   'data' => ['order_id' => 123, 'table' => 'Table 5'],
 * ];
 * 
 * $ch = curl_init('http://localhost:8080/trigger');
 * curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
 * curl_setopt($ch, CURLOPT_POST, true);
 * curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
 * curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
 * $response = curl_exec($ch);
 * curl_close($ch);
 */ 
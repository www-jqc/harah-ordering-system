<?php
/**
 * WebSocket Server for Real-time Notifications
 * 
 * This script provides a WebSocket endpoint for real-time notifications
 * to the mobile app. It requires Ratchet WebSocket server.
 * 
 * Note: This is a simplified version. For production, you would typically
 * run this as a daemon using Supervisor or similar.
 */

// If running in CLI mode as a daemon
if (php_sapi_name() == 'cli') {
    require __DIR__ . '/../vendor/autoload.php';
    require_once __DIR__ . '/../config/database.php';
    
    use Ratchet\Server\IoServer;
    use Ratchet\Http\HttpServer;
    use Ratchet\WebSocket\WsServer;
    use React\EventLoop\Factory;
    use React\Socket\SecureServer;
    use React\Socket\Server;
    
    class NotificationServer implements \Ratchet\MessageComponentInterface {
        protected $clients;
        protected $conn;
        protected $lastCheck = 0;
        
        public function __construct($conn) {
            $this->clients = new \SplObjectStorage;
            $this->conn = $conn;
            $this->lastCheck = time();
            
            // Set up periodic checking for new notifications
            $loop = \React\EventLoop\Factory::create();
            $loop->addPeriodicTimer(1, function() {
                $this->checkForNewNotifications();
            });
            
            echo "Notification server started\n";
        }
        
        public function onOpen(\Ratchet\ConnectionInterface $conn) {
            // Store this connection without role filtering
            $this->clients->attach($conn);
            
            echo "New connection! ({$conn->resourceId})\n";
        }
        
        public function onMessage(\Ratchet\ConnectionInterface $from, $msg) {
            // We don't expect clients to send messages for this application
            // But could handle custom subscription requests here
        }
        
        public function onClose(\Ratchet\ConnectionInterface $conn) {
            // Remove connection
            $this->clients->detach($conn);
            
            echo "Connection {$conn->resourceId} has disconnected\n";
        }
        
        public function onError(\Ratchet\ConnectionInterface $conn, \Exception $e) {
            echo "An error has occurred: {$e->getMessage()}\n";
            $conn->close();
        }
        
        protected function checkForNewNotifications() {
            // Check for new notifications since last check
            try {
                $now = time();
                $stmt = $this->conn->prepare("
                    SELECT * FROM notifications 
                    WHERE UNIX_TIMESTAMP(created_at) >= ? 
                    ORDER BY created_at DESC
                ");
                $stmt->execute([$this->lastCheck]);
                $notifications = $stmt->fetchAll(\PDO::FETCH_ASSOC);
                
                if (!empty($notifications)) {
                    foreach ($notifications as $notification) {
                        $this->broadcastNotification($notification);
                    }
                }
                
                $this->lastCheck = $now;
            } catch (\PDOException $e) {
                echo "Database error: {$e->getMessage()}\n";
            }
        }
        
        protected function broadcastNotification($notification) {
            echo "Broadcasting notification {$notification['notification_id']} to all clients\n";
            
            foreach ($this->clients as $client) {
                $message = json_encode([
                    'type' => 'notification',
                    'notification' => $notification
                ]);
                $client->send($message);
            }
        }
    }
    
    // Start the server
    $loop = Factory::create();
    $socket = new Server('0.0.0.0:8080', $loop);
    
    $server = new IoServer(
        new HttpServer(
            new WsServer(
                new NotificationServer($conn)
            )
        ),
        $socket,
        $loop
    );
    
    echo "Starting WebSocket server on port 8080\n";
    $server->run();
}
// If accessed via HTTP (for setup/test/fallback)
else {
    header('Content-Type: application/json');
    
    // Include the database connection
    require_once '../config/database.php';
    
    try {
        // Get the latest notification for the role
        $stmt = $conn->prepare("
            SELECT * FROM notifications 
            ORDER BY created_at DESC
            LIMIT 1
        ");
        $stmt->execute();
        $notification = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($notification) {
            echo json_encode([
                'success' => true,
                'notification' => $notification
            ]);
        } else {
            echo json_encode([
                'success' => true,
                'notification' => null
            ]);
        }
    } catch (PDOException $e) {
        echo json_encode([
            'success' => false,
            'message' => 'Database error: ' . $e->getMessage()
        ]);
    }
}
?> 
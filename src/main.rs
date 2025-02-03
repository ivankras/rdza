use serde::Serialize;
use warp::Filter;

#[derive(Serialize)]
struct HealthMessage {
    message: String,
}

#[tokio::main]
async fn main() {
    // Determine the environment (default to "dev")
    let env = std::env::var("APP_ENV").unwrap_or_else(|_| "dev".to_string());

    // Set the bind address based on the environment
    let bind_address = if env == "dev" {
        ([127, 0, 0, 1], 3030)
    } else {
        ([0, 0, 0, 0], 3030)
    };

    println!("Server is running on {:?}", bind_address);

    // Define the `/health` endpoint
    let message_route = warp::path!("health")
        .map(|| {
            let msg = HealthMessage {
                message: "Rust Service OK".to_string(),
            };
            warp::reply::json(&msg)
        });

    // Start the server
    warp::serve(message_route)
        .run(bind_address)
        .await;
}

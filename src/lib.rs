pub type Result<T> = std::result::Result<T, Box<dyn std::error::Error + Send + Sync>>;

pub mod lspc;
pub mod rpc;

pub use crate::lspc::Lspc;

// sample.rs — minimal test for xmc Rust parsing
use std::collections::HashMap;

pub trait Greeter {
    fn greet(&self) -> String;
}

pub struct Person {
    pub name: String,
    age: u32,
}

impl Greeter for Person {
    fn greet(&self) -> String {
        format!("Hello, {}", self.name)
    }
}

impl Person {
    pub fn new(name: String, age: u32) -> Self { Person { name, age } }
    pub fn age(&self) -> u32 { self.age }
}

pub enum Role { Admin, User }

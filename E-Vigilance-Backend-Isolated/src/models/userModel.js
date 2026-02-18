const storage = require('../data/storage');

class UserModel {
  // Create new user
  static createUser(userData) {
    const { name, email, nic, password } = userData;
    const role = 'citizen';
    
    const newUser = {
      id: storage.nextUserId++,
      name,
      email,
      nic,
      password,
      role,
      createdAt: new Date().toISOString()
    };
    
    storage.users.push(newUser);
    return newUser;
  }

  // Find user by email
  static findByEmail(email) {
    return storage.users.find(user => user.email === email);
  }

  // Find user by NIC
  static findByNIC(nic) {
    return storage.users.find(user => user.nic === nic);
  }

  // Find user by ID
  static findById(id) {
    const user = storage.users.find(user => user.id === id);
    if (!user) return null;
    
    // Return user without password
    const { password, ...userWithoutPassword } = user;
    return userWithoutPassword;
  }

  // Check if email exists
  static emailExists(email) {
    return !!this.findByEmail(email);
  }

  // Check if NIC exists
  static nicExists(nic) {
    return !!this.findByNIC(nic);
  }
}

module.exports = UserModel;
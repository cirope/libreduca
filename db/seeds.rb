User.create!(
  name: 'Admin',
  lastname: 'Admin',
  email: 'admin@edook.com',
  password: '123456',
  password_confirmation: '123456',
  roles: User.valid_roles
)
## Customers
[index of customers](usefulmusic.herokuapp.com/admin/customers)

### Attributes

*on signup*

- **First name**
  - length 2 - 26 charachters
  - Capitalised
  - Required
- **Last name**
  - length 2 - 26 charachters
  - Capitalised
  - Required
- **Email**
  - no legth limit
  - single '@' required
  - Required
- **Password**
  - length 8 - 55 charachters
  - no legth limit
  - single '@' required
  - Required
- **Country**
  - From drop down list
  - Required

*available in edit*

- **Question 1**
- **Question 2**
- **Question 3**

*admin*

- **id**
  - random string
- **admin**
  - true/false
- **Password_reset_token**
  - random string
- **password_reset_created_at**
  - DateTime
- **created_at**
  - DateTime
- **updated_at**
  - DateTime
- **last_login_at**
  - DateTime

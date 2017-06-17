import gql from "graphql-tag";

export default gql`
  mutation RegisterUser($email: String, $password: String, $username: String){
    registerUser(email: $email, 
                 password: $password, 
                 username: $username) {
      token
      user{
        id
        email
        username
      }
    }
  }  
`;
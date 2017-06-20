import gql from "graphql-tag";

export default gql`
  mutation LoginUser($email: String, $password: String, $username: String){
    loginUser(email: $email, 
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
import gql from "graphql-tag";

export default gql`
  mutation LoginUser($password: String, $username: String){
    loginUser(password: $password, username: $username) {
      token
      user{
        id
        username
      }
    }
  }  
`;
import gql from 'graphql-tag'

export default gql`
  query Thread($title: String, $network: String){
    thread(title: $title, network: $network) {
      id
    }
  }
`;
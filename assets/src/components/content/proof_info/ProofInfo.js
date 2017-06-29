import React,{Component} from 'react';
import styles from './style.css'

class ProofInfo extends Component {
    constructor(props) {
        super(props);

        this.state = {
            article: '',
            link: '',
            title: '',
            authors: ''
        };
    }
    componentWillMount(){
        console.log('componentWillMount',this.props.data);
        // this.setState({
        //     link: this.props.data.doi,
        //     title: '',
        //     authors: ''
        // })
    }
    onSubmit(event){
        event.preventDefault()
    }

    render(){
        return(
            <div className={styles['work-info']}>
                <form onSubmit={this.onSubmit.bind(this)}>
                    <textarea placeholder="article text goes here"
                              onChange={() => this.setState({article: event.target.value})}>
                    </textarea>
                    <button onClick={console.log('ProofInfo!')}>Proof</button>
                </form>
            </div>
        )
    }
}

export default ProofInfo
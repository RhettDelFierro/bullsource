import React, {Component} from "react";
import {Editor, Raw} from "slate";
import {withApollo, graphql} from 'react-apollo'
import keycode from "keycode";
import {initialState} from "../../../helpers/slate";
import styles from "./style.css";
import checkDoiQuery from "../../../queries/checkDOI";
import DOIBlock from "../doi_block/DOIBlock";


const DEFAULT_NODE = 'paragraph';

const schema = {
    nodes: {
        doiBlock: DOIBlock
    },
    marks: {
        bold: props => <strong>{props.children}</strong>,
        code: props => <code>{props.children}</code>,
        italic: props => <em>{props.children}</em>,
        strikethrough: props => <del>{props.children}</del>,
        underline: props => <u>{props.children}</u>,
    }
};

class FormEditor extends Component {
    constructor(props){
        super(props);
        this.state = {
            state: initialState,
            showDOI: false,
            doi: '',
            dois: [],
            doiErrorMessage: ''
        };
        this.focus = () => this.refs.editor.focus();

    }

    onDOIChange = (e) => this.setState({doi: e.target.value});

    onToggleDOI() {
        this.setState({showDOI: true})
    }

    confirmDOI(e){
        e.preventDefault();
        // this.setState({
        //     dois: [this.state.doi, ...this.state.dois],
        //     doi: '',
        //     showDOI: false
        // });

        const isCode = this.state.state.blocks.some(block => block.type == 'code');

        let state = this.state.state
            .transform()
            .setBlock('doiBlock')
            .apply();

        this.setState({
            state,
            dois: [this.state.doi, ...this.state.dois],
            doi: '',
            showDOI: false
        });
    };

    onCheckInvalidDOI = (errorMessage) => {
        let [_a, ...rest] = this.state.dois;

        this.setState({
            dois: rest,
            doiErrorMessage: errorMessage
        })
    };

    onChange = (state) => this.setState({state});

    render = () => {
        console.log(Raw.serialize(this.state.state));
        let doiInput;
        if (this.state.showDOI) {
            //the doi "form" that gets toggled if this.state.showDOIInput is true:
            doiInput =
                <div className={styles['doi-input-container']}>
                    <input
                        onChange={this.onDOIChange}
                        ref="doi"
                        className={styles['doi-input']}
                        type="text"
                        value={this.state.doi}
                    />
                    <button onClick={(event) => this.confirmDOI(event)}>
                        Confirm
                    </button>
                </div>;
        }
        return (
            <div className={styles['form-container']}>
                {doiInput}
                <button onClick={this.onToggleDOI.bind(this)}>Show DOI</button>
                <Editor
                    plugins={plugins}
                    schema={schema}
                    state={this.state.state}
                    onChange={this.onChange}
                    doi={this.state.dois}
                    onCheckInvalidDOI={this.onCheckInvalidDOI}
                />
            </div>
        )
    }
}

// Create an array of plugins.
const plugins = [
    MarkHotkey({ key: 'b', type: 'bold' }),
    MarkHotkey({ key: 'c', type: 'code', isAltKey: true }),
    MarkHotkey({ key: 'i', type: 'italic' }),
    MarkHotkey({ key: 'd', type: 'strikethrough' }),
    MarkHotkey({ key: 'u', type: 'underline' })
];

function MarkHotkey(options) {
    // Grab our options from the ones passed in.
    const {type, key, isAltKey = false} = options;
    return {
        onKeyDown(event, data, state) {
            // Change the comparison to use the key name.
            if (!event.metaKey || keycode(event.which) != key || event.altKey != isAltKey) return;
            event.preventDefault();
            return state
                .transform()
                .toggleMark(type)
                .apply()
        }
    }
}

export default FormEditor
import React, {Component} from "react";
import {AtomicBlockUtils, convertToRaw, Editor, EditorState} from "draft-js";
import styles from "./style.css";
import {getBlockRendererFn, REFERENCE_TYPE} from "../../../helpers/forms";
import ReferenceModal from '../reference_modal/ReferenceModal';

class FormEditor extends Component {
    constructor(props) {
        super(props);
        this.state = {
            editorState: EditorState.createEmpty(),
            showDOI: false,
            showModal: false,
            doi: '',
        };

        this.getEditorState = () => this.state.editorState;
        this.onChange = (editorState) => this.setState({editorState}, () => {
            setTimeout(() => this.focus(), 0);
        });
        this.addDOI = this.addDOI.bind(this);
        this.confirmDOI = this.confirmDOI.bind(this);
        this.focus = () => this.refs.editor.focus();
        this.onLoadEntity = this.onLoadEntity.bind(this);
    }

    confirmDOI(e) {
        e.preventDefault();
        this.setState({showModal: true})
    }

    onLoadEntity(reference) {
        const { doi,url,title,source,date,authors } = reference;
        const {editorState} = this.state;
        const contentState = editorState.getCurrentContent();
        const contentStateWithEntity = contentState.createEntity(
            REFERENCE_TYPE,
            'IMMUTABLE',
            {doi,url,title,source,date,authors}
        );

        const entityKey = contentStateWithEntity.getLastCreatedEntityKey();
        const newEditorState = EditorState.set(
            editorState,
            {currentContent: contentStateWithEntity}
        );

        //sets entity before response from query:
        this.setState({
            editorState: AtomicBlockUtils.insertAtomicBlock(
                newEditorState,
                entityKey,
                ' '
            ),
            showDOI: false,
            doi: '',
            showModal: false
        }, () => {
            setTimeout(() => this.focus(), 0);
        });
    }


    addDOI() {
        this.setState({
            showDOI: true,
            doi: ''
        }, () => {
            setTimeout(() => this.refs.doi.focus(), 0);
        });
    }

    render() {
        console.log(convertToRaw(this.state.editorState.getCurrentContent()));
        let doiInput;
        if (this.state.showDOI) {
            doiInput =
                <div>
                    <input
                        onChange={(e) => this.setState({doi: e.target.value})}
                        ref="doi"
                        type="text"
                        value={this.state.doi}
                    />
                    <button onMouseDown={this.confirmDOI}>
                        Confirm
                    </button>
                </div>;
        }
        return (
            <div className={styles['full-container']}>
                <button onClick={this.addDOI}>Add DOI</button>
                {doiInput}
                <div className={styles['form-container']} onClick={this.focus}>
                    <Editor editorState={this.state.editorState}
                            ref="editor"
                            placeholder="Write here..."
                            onChange={this.onChange}
                            blockRendererFn={getBlockRendererFn}
                    />
                </div>
                {this.state.showModal ?
                    <ReferenceModal doi={this.state.doi} onLoadEntity={this.onLoadEntity}/>
                    : <div/>
                }
            </div>
        )
    }
}

export default FormEditor;
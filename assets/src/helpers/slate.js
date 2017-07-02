import {Raw} from "slate";
export const initialState = Raw.deserialize({
    nodes: [
        {
            kind: 'block',
            type: 'paragraph',
            nodes: [
                {
                    kind: 'text',
                    text: 'A line of text in a paragraph.'
                }
            ]
        }
    ]
}, {terse: true});
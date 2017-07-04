import {Map} from 'immutable';

/*Returns a function that waits for the content block
*
* Return:
*  ContentBlock -> Map
* */
export const organizeReferenceData = (doi) => (block) => {
    const {url, title, indexed, containerTitle, author} = doi[0];
    const authors = author.map(name => `${name.given} ${name.family}`).join(', ');
    const doiInfo = Map({
        url,
        title: title[0],
        source: containerTitle[0],
        date: `${indexed.dateParts[0][1]}/${indexed.dateParts[0][2]}/${indexed.dateParts[0][0]}`,
        authors: authors,
        fetched: true
    });

    const data = block.getData();
    return data.merge(doiInfo);
};
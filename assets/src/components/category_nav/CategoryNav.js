import React from 'react';
import { NavLink } from 'react-router-dom'
import './style.css'

export const CategoryNav = () => {
    return (
        <ul className='nav'>
            <li>
                <NavLink activeClassName='active' to='category/entertainment'>Entertainment</NavLink>
            </li>
            <li>
                <NavLink activeClassName='active' to='category/gaming'>Gaming</NavLink>
            </li>
            <li>
                <NavLink activeClassName='active' to='category/general'>General</NavLink>
            </li>
            <li>
                <NavLink activeClassName='active' to='category/music'>Music</NavLink>
            </li>
            <li>
                <NavLink activeClassName='active' to='category/politics'>Politics</NavLink>
            </li>
            <li>
                <NavLink activeClassName='active' to='category/science-and-nature'>Science and Nature</NavLink>
            </li>
            <li>
                <NavLink activeClassName='active' to='category/sport'>Sport</NavLink>
            </li>
            <li>
                <NavLink activeClassName='active' to='category/technology'>Technology</NavLink>
            </li>
        </ul>
    )
};


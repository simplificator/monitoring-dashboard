import React from 'react';
import {Widget, Helpers} from 'kitto';

import './trafficlight.scss';

class ListItem extends React.Component {
  render() {
    return (
      <li>
        <span className="label">
          {Helpers.truncate(this.props.label, this.props.labelLength || 80)}
        </span>
        <span className="value">
          {Helpers.truncate(this.props.value, this.props.valueLength)}
        </span>
      </li>
    );
  }
}

export class Trafficlight extends Widget {
  renderItems(items) {
    return items.map((item, i) => {
      return <ListItem key={i}
                       label={item.label}
                       value={item.value}
                       labelLength={+this.props.labelLength}
                       valueLength={+this.props.valueLength}/>;
    });
  }
  renderList(items) {
    <ul>{items}</ul>;
  }
  render() {
  if(this.state.items == [] || this.state.items == '' || this.state.items == undefined){
      return(
      <div className={this.props.className} id="up">
              <h1 className="title">{this.props.title}</h1>
              <h3>{this.props.text}</h3>
              <h2>Up</h2>

              <p className="more-info">{this.props.moreinfo}</p>
              <p className="updated-at">{this.updatedAt(this.state.updated_at)}</p>
            </div>
      );
    }else{
    return (
          <div className={this.props.className} id="down">
            <h1 className="title">{this.props.title}</h1>
            <h3>{this.props.text}</h3>
            <h2>Down</h2>
            <ul>
              {this.renderList(this.renderItems(this.state.items || []))}
            </ul>

            <p className="more-info">{this.props.moreinfo}</p>
            <p className="updated-at">{this.updatedAt(this.state.updated_at)}</p>
          </div>
        );
    }
  }
};

Widget.mount(Trafficlight);
export default Trafficlight;

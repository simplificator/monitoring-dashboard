import ReactDOM from 'react-dom';
import React from 'react';
import 'd3';
import 'rickshaw';
import {Kitto, Widget} from 'kitto';

import './graph.scss';

class Graph extends Widget {
  static get defaultProps() {
    return { graphType: 'area'};
  }

  componentDidMount() {
    this.$node = $(ReactDOM.findDOMNode(this));
    this.renderGraph();
  }
    renderGraph() {
      let container = this.$node.parent();
      let $gridster = $('.gridster');
      let config = Kitto.config();
      let widget_base_dimensions = config.widget_base_dimensions;
      let width = (widget_base_dimensions[0] *
                   container.data('sizex')) + 5 * 2 * (container.data('sizex') - 1);
      let height = (widget_base_dimensions[1] * container.data('sizey'));
      let type = 'area'
      let series = [{color: '#fff', data: [{x: 0, y: 0}]}]
      let min = 'auto'

      if(this.props.graphType=='version'){
        type = 'area'
        var labels = this.props.labels.split(',')
        series = [{color: '#8EC662', data: [{ x: 0, y: 0 },{ x: 1, y: 0 }], name: '1'},{color: '#EEA339', data: [{ x: 0, y: 0 },{ x: 1, y: 0 }],name: '2'},{color: '#E5524B', data: [{ x: 0, y: 0 },{ x: 1, y: 0 }],name: '3'}]
        series[0].name = series[0].data[0].y + " " + labels[0]
        series[1].name = series[1].data[0].y + " " + labels[1]
        series[2].name = series[2].data[0].y + " " + labels[2]
        min = 0
        width = 0.7*width
      } else {
        type = this.props.graphType
      }

      this.graph = new Rickshaw.Graph({
        element: this.$node[0],
        width: width,
        height: height,
        min: min,
        renderer: type,
        series: series
      });
      if(this.props.yformat === 'percentage'){
        var format = d3.format(",.2%");
        console.log(this.props.title)
      } else {
        var format = Rickshaw.Fixtures.Number.formatKMBT
        console.log(this.props.title)
      }
      new Rickshaw.Graph.Axis.Y({ graph: this.graph,
                                  tickFormat: format });
      this.graph.render();
      if(this.props.graphType=='version'){
              this.legend = new Rickshaw.Graph.Legend({
                  graph: this.graph,
                  element: document.getElementById(this.props.id)
              });
            }
    }
  componentWillUpdate(_props, state) {
    if(state.points != undefined){
      this.graph.series[0].data = state.points;
      var labels = state.labels
      new Rickshaw.Graph.Axis.X({ graph: this.graph,
                                        tickFormat: function(x) {
                                            return labels[x];
                                        }
                                    });
    } else if (state.versions != undefined){
      var labels = this.props.labels.split(',')
      var count = state.versions
      this.graph.series[0].data[0].y=count[0]
      this.graph.series[0].data[1].y=count[0]
      this.graph.series[1].data[0].y=count[1]
      this.graph.series[1].data[1].y=count[1]
      this.graph.series[2].data[0].y=count[2]
      this.graph.series[2].data[1].y=count[2]

      this.graph.series[0].name = count[0] + " " + labels[0]
      this.graph.series[1].name = count[1] + " " + labels[1]
      this.graph.series[2].name = count[2] + " " + labels[2]
      jQuery(document.getElementById(this.props.id)).empty();
      this.legend = new Rickshaw.Graph.Legend({
                             graph: this.graph,
                             element: document.getElementById(this.props.id)
                         });

    }
    this.graph.render();
  }
  render() {
  if(this.props.graphType != 'version'){
    return (
      <div className={this.props.className}>
        <h1 className="title">{this.props.title}</h1>
        <p className="more-info">{this.props.moreinfo}</p>
        <p className="updated-at">{this.updatedAt(this.state.updated_at)}</p>
      </div>
    );
    }else{
    return (
          <div id="widget-version" className={this.props.className}>
            <h1 className="title">{this.props.title}</h1>
            <p className="updated-at">{this.updatedAt(this.state.updated_at)}</p>
            <p className="more-info">{this.props.moreinfo}</p>
            <div id={this.props.id} className='legend'></div>
          </div>
        );
    }
  }
};

Widget.mount(Graph);
export default Graph;

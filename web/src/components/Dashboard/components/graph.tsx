import React from "react";
import CanvasJSReact from "@canvasjs/react-charts";

const CanvasJSChart = CanvasJSReact.CanvasJSChart;

interface EnergyUsageChartProps {
  month1: string;
  month2: string;
  dataMonth1: { x: Date; y: number }[];
  dataMonth2: { x: Date; y: number }[];
}

const EnergyUsageChart: React.FC<EnergyUsageChartProps> = ({
  month1,
  month2,
  dataMonth1,
  dataMonth2,
}) => {
  const options = {
    theme: "light2",
    axisX: {
      title: "Days",
      valueFormatString: "DD",
    },
    axisY: {
      title: "Energy Consumption (kWh)",
      suffix: " kWh",
    },
    toolTip: {
      shared: true,
    },
    legend: {
      cursor: "pointer",
      itemclick: (e: any) => {
        e.dataSeries.visible =
          typeof e.dataSeries.visible === "undefined" || e.dataSeries.visible;
        e.chart.render();
      },
    },
    data: [
      {
        type: "area",
        name: month1,
        showInLegend: true,
        xValueFormatString: "DD MMM",
        yValueFormatString: "#,##0 kWh",
        markerSize: 0,
        fillOpacity: 0.5,
        dataPoints: dataMonth1,
      },
      {
        type: "area",
        name: month2,
        showInLegend: true,
        xValueFormatString: "DD MMM",
        yValueFormatString: "#,##0 kWh",
        markerSize: 0,
        fillOpacity: 0.5,
        dataPoints: dataMonth2,
      },
    ],
  };

  return (
    <div style={{ width: "100%", height: "100%" }}>
      <CanvasJSChart options={options} />
    </div>
  );
};

export default EnergyUsageChart;

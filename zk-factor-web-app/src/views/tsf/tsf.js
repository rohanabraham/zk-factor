import HandPoseDetection from "./components/hand-pose-detection";
import { Row, Col } from "react-bootstrap";

const Ezkl = () => {
  return (
    <div>
      <div className="text-center">
        <h2>ZK Factor</h2>
        <p>Aztec Sandbox - Private state with Multi factors!</p>
      </div>

      <Row>
        <Col>
          <HandPoseDetection />
        </Col>
      </Row>
    </div>
  );
};

export default Ezkl;

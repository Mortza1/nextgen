import React, { useState } from 'react';
import styles from '@app/components/Authentication/styles.module.css';
import { useAuth } from "@app/contexts/AuthContext";

const AuthPage: React.FC = () => {
  const [email, setEmail] = useState("");
  const [name, setName] = useState("");
  const [password, setPassword] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [isRegistering, setIsRegistering] = useState(false); // State to toggle between login and register
  const {register, login} = useAuth();

  const handleEmailChange = (e: { target: { value: React.SetStateAction<string>; }; }) => {
    setEmail(e.target.value);
  };
  const handleNameChange = (e: { target: { value: React.SetStateAction<string>; }; }) => {
    setName(e.target.value);
  };

  const handlePasswordChange = (e: { target: { value: React.SetStateAction<string>; }; }) => {
    setPassword(e.target.value);
  };

  const handleSubmit = () => {
    setIsLoading(true);
    if (isRegistering) {
      register(name, email, password);
    } else {
      login(email, password);
    }
    setIsLoading(false);
  };

  return (
    <div className={styles.loginPage}>
      <div className={styles.loginBlock}>
        <img
          src="files.png"
          alt="Login Image"
          className={styles.loginImage}
        />
        <div className={styles.eco}>Eco Hive</div>
        <div className={styles.ecosub}>Your Home, Smarter. Your Life, Simpler. Step into the Future Today!</div>
      </div>
      <div className={styles.loginFieldContainer}>
        <img src="logo.png" alt="" height={60} />
        <div className={styles.loginButtonContainer}>
          {isRegistering && (
            <input
              value={name}
              onChange={handleNameChange}
              className={styles.input}
              id="name"
              type="text"
              placeholder="Full name"
            />
          )}
          <input
            value={email}
            onChange={handleEmailChange}
            className={styles.input}
            id="email"
            type="text"
            placeholder="Email Address"
          />
          <input
            value={password}
            onChange={handlePasswordChange}
            className={styles.input}
            id="password"
            type="password"
            placeholder="Password"
          />
          <button
            type="button"
            onClick={handleSubmit}
            className={styles.button}
          >
            {isLoading ? <div className="continueButton">
              <div className={styles.spinner}></div>
            </div> : isRegistering ? 'Register' : 'Login'}
          </button>

          <div className={styles.orContainer}>
            <div className={styles.line}></div>
            <div className={styles.or}>OR</div>
            <div className={styles.line}></div>
          </div>
          <button
            type="button"
            onClick={() => setIsRegistering(!isRegistering)}
            className={styles.textButton}
          >
            {isRegistering ? 'Login' : 'Register'}
          </button>
        </div>
      </div>
    </div>
  );
};

export default AuthPage;
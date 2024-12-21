import React, { useState } from 'react';
import { GoogleOAuthProvider } from '@react-oauth/google';
import styles from '@app/components/Authentication/styles.module.css';
import { CircularProgress } from '@mui/material';
import { useAuth } from "@app/contexts/AuthContext";


const AuthPage: React.FC = () => {
  const [email, setEmail] = useState("");
  const [name, setName] = useState("");
  const [password, setPassword] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const {register} = useAuth();

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
    register(name, email, password);
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
        </div>
        <div className={styles.loginFieldContainer}>
          <h1><strong>NexGen</strong></h1>
          <div className={styles.logoWelcome}>
            Welcome to NexGen Software! 👋
          </div>
          <div className={styles.logoSubText}>
            Please sign-in to your account to continue.
        </div>
        
          <div className={styles.loginButtonContainer}>
          <input
            value={name}
            onChange={handleNameChange}
            className={styles.input}
            id="name"
            type="text"
            placeholder="Full name"
          />
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
            placeholder="password"
          />
          {(
          <button
            type="button"
            onClick={handleSubmit}
            className={styles.button}
          > {isLoading ? <div className="continueButton">
            <div className={styles.spinner}></div>
          </div> : 'Continue'}
          </button>
        )}
        </div>
        </div>
      </div>
    
  );
};

export default AuthPage;

import React, { createContext, useState, useContext, useEffect } from 'react';
import { loginUser, registerManager} from '@app/api/actions';
import { getUserFromToken } from '@app/components/Authentication/tokenUtils';


interface AuthContextType {
  isAuthenticated: boolean;
  login: (email: string, password: string) => void;
  logout: () => void;
  register: (name:string, email: string, password: string) => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

export const AuthProvider: React.FC<React.PropsWithChildren> = ({ children }) => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    const token = localStorage.getItem('authToken');
    if (token) {
      const decodedUser = getUserFromToken(token);
      if (decodedUser) {
        setIsAuthenticated(true);
      }
    }
  }, []);

  const login = async (email: string, password: string) => {
    try {
      const userId = await loginUser({ email, password });
      if (userId) {
        localStorage.setItem('authToken', userId['user_id']);
        // const decodedUser = getUserFromToken(userId['user_id']);
        // if (decodedUser) {
          setIsAuthenticated(true);
        // }
      }
    } catch (error) {
      setIsAuthenticated(false);
      console.error('Registration failed:', error);
    }
  };

  const logout = () => {
    localStorage.removeItem('authToken');
    localStorage.removeItem('tokenType');
    localStorage.removeItem('isLoggedIn');
    localStorage.removeItem('userId')
    setIsAuthenticated(false);
  };

  const register = async (name : string, email: string, password: string) => {
    try {
      const userId = await registerManager({ name, email, password });
      if (userId) {
        localStorage.setItem('authToken', userId['user_id']);
        // const decodedUser = getUserFromToken(userId['user_id']);
        // if (decodedUser) {
          setIsAuthenticated(true);
        // }
      }
    } catch (error) {
      setIsAuthenticated(false);
      console.error('Registration failed:', error);
    }
  };

  return (
    <AuthContext.Provider value={{ isAuthenticated, logout, login, register }}>
      {children}
    </AuthContext.Provider>
  );
};

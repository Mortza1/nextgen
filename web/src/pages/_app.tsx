import '@app/styles/globals.css';
import type { AppProps } from 'next/app';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import RootPageLayout from '@app/components/RootPageLayout';
import { AuthProvider, useAuth } from '@app/contexts/AuthContext';
import AuthPage from '@app/components/Authentication/AuthPage';
import { useState, useEffect } from 'react';

const queryClient = new QueryClient();

const LoadingSpinner: React.FC = () => (
  <div className="spinner-container">
    <div className="spinner"></div>
  </div>
);

const AuthenticatedApp: React.FC<{ Component: React.ComponentType<any>, pageProps: any }> = ({ Component, pageProps }) => {
  const { isAuthenticated } = useAuth();
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(false);
  }, []);


  if (loading) {
    return <LoadingSpinner />;
  }

  if (!isAuthenticated) {
    return <AuthPage/>;
  }

  return (
    
      <RootPageLayout>
        <Component {...pageProps} />
      </RootPageLayout>
    
  );
};

export default function App({ Component, pageProps }: AppProps) {
  return (
    <QueryClientProvider client={queryClient}>
      <AuthProvider>
        <AuthenticatedApp Component={Component} pageProps={pageProps} />
      </AuthProvider>
    </QueryClientProvider>
  );
}
